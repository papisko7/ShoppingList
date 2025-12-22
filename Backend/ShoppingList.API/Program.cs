using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Scalar.AspNetCore;
using ShoppingList.API.Services;
using ShoppingList.API.Services.Interfaces;
using ShoppingList.API.Services.Login;
using ShoppingList.Data.Database;
using System.Text;
using System.Threading.RateLimiting;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddOpenApi(options =>
{
	options.AddDocumentTransformer((document, context, cancellationToken) =>
	{
		// 1. Define the Security Scheme (Bearer Token)
		var securityScheme = new OpenApiSecurityScheme
		{
			Name = "Authorization",
			Type = SecuritySchemeType.Http,
			Scheme = "bearer",
			BearerFormat = "JWT",
			In = ParameterLocation.Header,
			Description = "Enter your token."
		};

		document.Components ??= new OpenApiComponents();
		document.Components.SecuritySchemes.Add("Bearer", securityScheme);

		// 2. Apply it globally to all endpoints
		var requirement = new OpenApiSecurityRequirement
		{
			{
				new OpenApiSecurityScheme
				{
					Reference = new OpenApiReference
					{
						Type = ReferenceType.SecurityScheme,
						Id = "Bearer"
					}
				},
				new string[] {}
			}
		};

		document.SecurityRequirements.Add(requirement);
		return Task.CompletedTask;
	});
});

builder.Services.AddDbContext<ShoppingListDbContext>(options =>
	options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
	.AddJwtBearer(options =>
	{
		options.TokenValidationParameters = new TokenValidationParameters
		{
			ValidateIssuerSigningKey = true,
			IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(
				builder.Configuration.GetSection("JwtSettings:SecretKey").Value!)),
			ValidateIssuer = false,
			ValidateAudience = false,
			ClockSkew = TimeSpan.Zero
		};
	});

builder.Services.AddRateLimiter(options =>
{
	options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;

	options.AddPolicy("IpLimiter", httpContext =>
		RateLimitPartition.GetFixedWindowLimiter(
			partitionKey: httpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown",
			factory: _ => new FixedWindowRateLimiterOptions
			{
				PermitLimit = 5,
				Window = TimeSpan.FromMinutes(1),
				QueueLimit = 0
			}));
});

builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<ITokenService, TokenService>();
builder.Services.AddScoped<IListService, ListService>();

builder.Services.AddCors(options =>
{
	options.AddPolicy("ShoppingListFrontend", policy =>
	{
		policy.WithOrigins("http://localhost:5500", "https://myshoppingapp.com")
			  .AllowAnyMethod()
			  .AllowAnyHeader();
	});
});

var app = builder.Build();

app.Use(async (context, next) =>
{
	try
	{
		await next();
	}
	catch (Exception ex)
	{
		context.Response.StatusCode = 500;
		await context.Response.WriteAsJsonAsync(new { error = "An unexpected error occurred." });
		Console.WriteLine(ex.Message);
	}
});

if (app.Environment.IsDevelopment())
{
	app.MapOpenApi();
	app.MapScalarApiReference();
}

app.UseHttpsRedirection();
app.UseRateLimiter();
app.UseAuthentication();
app.UseAuthorization();
app.UseCors("ShoppingListFrontend");

app.MapControllers();

app.Run();
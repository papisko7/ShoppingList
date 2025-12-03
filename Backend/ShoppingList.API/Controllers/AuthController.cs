using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using ShoppingList.Data.Database;
using ShoppingList.Data.Entities.Login;
using ShoppingList.API.DTOs; 
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace ShoppingList.API.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class AuthController : ControllerBase
	{
		private readonly ShoppingListDbContext _context;
		private readonly IConfiguration _configuration;

		public AuthController(ShoppingListDbContext context, IConfiguration configuration)
		{
			_context = context;
			_configuration = configuration;
		}

		[HttpPost("register")]
		public async Task<ActionResult<UserDto>> Register(RegisterDto request)
		{
			// 1. Check if user exists
			if (await _context.Users.AnyAsync(u => u.Username == request.Username))
			{
				return BadRequest("User already exists.");
			}

			// 2. Hash Password
			string passwordHash = BCrypt.Net.BCrypt.HashPassword(request.Password);

			// 3. Create Entity (With unsafe data like PasswordHash)
			var user = new User
			{
				Username = request.Username,
				PasswordHash = passwordHash,
				CreatedAt = DateTime.UtcNow
			};

			_context.Users.Add(user);
			await _context.SaveChangesAsync();

			// 4. Create Safe DTO (Only safe data)
			var safeResponse = new UserDto
			{
				Id = user.ID,
				Username = user.Username
			};

			return Ok(safeResponse);
		}

		[HttpPost("login")]
		public async Task<ActionResult> Login(LoginDto request)
		{
			var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == request.Username);

			if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
			{
				return BadRequest("Wrong username or password.");
			}

			string accessToken = CreateAccessToken(user);
			string refreshToken = GenerateRefreshToken();

			var tokenEntity = new Token
			{
				UserID = user.ID,
				RefreshToken = refreshToken,
				ExpiresAt = DateTime.UtcNow.AddDays(7),
				CreatedAt = DateTime.UtcNow
			};

			_context.Tokens.Add(tokenEntity);
			await _context.SaveChangesAsync();

			return Ok(new { AccessToken = accessToken, RefreshToken = refreshToken });
		}

		// --- Helpers ---
		private string CreateAccessToken(User user)
		{
			List<Claim> claims = new List<Claim>
			{
				new Claim(ClaimTypes.Name, user.Username),
				new Claim("UserId", user.ID.ToString())
			};

			var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(
				_configuration.GetSection("JwtSettings:SecretKey").Value!));

			var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);

			var token = new JwtSecurityToken(
				claims: claims,
				expires: DateTime.Now.AddMinutes(15),
				signingCredentials: creds
			);

			return new JwtSecurityTokenHandler().WriteToken(token);
		}

		private string GenerateRefreshToken()
		{
			var randomNumber = new byte[32];
			using var rng = RandomNumberGenerator.Create();
			rng.GetBytes(randomNumber);
			return Convert.ToBase64String(randomNumber);
		}
	}
}
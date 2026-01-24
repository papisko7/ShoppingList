using Microsoft.EntityFrameworkCore;
using ShoppingList.API.DTOs.Login;
using ShoppingList.API.Services.Interfaces;
using ShoppingList.Data.Database;
using ShoppingList.Data.Entities.Login;

namespace ShoppingList.API.Services.Login
{
	public class AuthService : IAuthService
	{
		private readonly ShoppingListDbContext _context;
		private readonly ITokenService _tokenService;
		private readonly IConfiguration _configuration;

		public AuthService(ShoppingListDbContext context, ITokenService tokenService, IConfiguration configuration)
		{
			_context = context;
			_tokenService = tokenService;
			_configuration = configuration;
		}

		public async Task<(bool Success, string Message, UserDto? User)> RegisterAsync(RegisterDto request)
		{
			request.Username = request.Username.ToLower();

			if (await _context.Users.AnyAsync(u => u.Username == request.Username))
			{
				return (false, "Username is taken.", null);
			}

			var passwordHash = BCrypt.Net.BCrypt.HashPassword(request.Password);

			var user = new UserEntity
			{
				Username = request.Username,
				PasswordHash = passwordHash,
				CreatedAt = DateTime.UtcNow
			};

			_context.Users.Add(user);
			await _context.SaveChangesAsync();

			return (true, "Success", new UserDto
			{
				Id = user.Id,
				Username = user.Username
			});
		}

		public async Task<(bool Success, string Message, string? AccessToken, string? RefreshToken)> LoginAsync(LoginDto request)
		{
			request.Username = request.Username.ToLower();

			var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == request.Username);

			if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
			{
				return (false, "Invalid username or password.", null, null);
			}

			var expiredTokens = await _context.Tokens
				.Where(t => t.UserID == user.Id && t.ExpiresAt <= DateTime.UtcNow)
				.ToListAsync();

			if (expiredTokens.Any())
			{
				_context.Tokens.RemoveRange(expiredTokens);
			}

			return await GenerateAndSaveTokensAsync(user);
		}

		public async Task<(bool Success, string Message, string? AccessToken, string? RefreshToken)> RefreshTokenAsync(RefreshTokenDto request)
		{
			var storedToken = await _context.Tokens
			   .Include(t => t.User)
			   .FirstOrDefaultAsync(t => t.RefreshToken == request.Token);

			if (storedToken == null)
			{
				return (false, "Invalid token.", null, null);
			}

			if (storedToken.ExpiresAt < DateTime.UtcNow)
			{
				_context.Tokens.Remove(storedToken);
				await _context.SaveChangesAsync();

				return (false, "Token expired.", null, null);
			}

			_context.Tokens.Remove(storedToken);
			return await GenerateAndSaveTokensAsync(storedToken.User);
		}

		private async Task<(bool, string, string, string)> GenerateAndSaveTokensAsync(UserEntity user)
		{
			var accessToken = _tokenService.CreateAccessToken(user);
			var refreshToken = _tokenService.GenerateRefreshToken();

			var tokenEntity = new TokenEntity
			{
				UserID = user.Id,
				RefreshToken = refreshToken,
				ExpiresAt = DateTime.UtcNow.AddDays(_configuration.GetValue<int>("JwtSettings:RefreshTokenExpirationDays", 7)),
				CreatedAt = DateTime.UtcNow
			};

			_context.Tokens.Add(tokenEntity);
			await _context.SaveChangesAsync();

			return (true, "Success", accessToken, refreshToken);
		}

		public async Task<(bool Success, string Message)> LogoutAsync(string refreshToken)
		{
			var token = _context.Tokens.FirstOrDefault(t => t.RefreshToken == refreshToken);

			if (token != null)
			{
				_context.Tokens.Remove(token);
				await _context.SaveChangesAsync();
			}

			return (true, "Logged out successfuly.");
		}
	}
}
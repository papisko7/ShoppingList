using ShoppingList.API.DTOs;

namespace ShoppingList.API.Services.Interfaces
{
	public interface IAuthService
	{
		public Task<(bool Success, string Message, UserDto? User)> RegisterAsync(RegisterDto request);

		public Task<(bool Success, string Message, string? AccessToken, string? RefreshToken)> LoginAsync(LoginDto request);

		public Task<(bool Success, string Message, string? AccessToken, string? RefreshToken)> RefreshTokenAsync(RefreshTokenDto request);

		public Task<(bool Success, string Message)> LogoutAsync(string refreshToken);
	}
}
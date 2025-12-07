using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using ShoppingList.API.DTOs;
using ShoppingList.API.Services.Interfaces;

namespace ShoppingList.API.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	[EnableRateLimiting("IpLimiter")]
	public class AuthController : ControllerBase
	{
		private readonly IAuthService _authService;

		public AuthController(IAuthService authService)
		{
			_authService = authService;
		}

		[HttpPost("register")]
		public async Task<ActionResult<UserDto>> Register(RegisterDto request)
		{
			var result = await _authService.RegisterAsync(request);

			if (!result.Success)
			{
				return BadRequest(result.Message);
			}
			return Ok(result.User);
		}

		[HttpPost("login")]
		[EnableRateLimiting("Fixed")]
		public async Task<IActionResult> Login(LoginDto request)
		{
			var result = await _authService.LoginAsync(request);

			if (!result.Success)
			{
				return BadRequest(result.Message);
			}
			return Ok(new { AccessToken = result.AccessToken, RefreshToken = result.RefreshToken });
		}

		[HttpPost("refresh-token")]
		public async Task<IActionResult> RefreshToken(RefreshTokenDto request)
		{
			var result = await _authService.RefreshTokenAsync(request);

			if (!result.Success)
			{
				return Unauthorized(result.Message);
			}

			return Ok(new { AccessToken = result.AccessToken, RefreshToken = result.RefreshToken });
		}

		[HttpPost("logout")]
		public async Task<IActionResult> Logout([FromBody] RefreshTokenDto request)
		{
			await _authService.LogoutAsync(request.Token);

			return Ok(new { message = "Logged out" });
		}
	}
}
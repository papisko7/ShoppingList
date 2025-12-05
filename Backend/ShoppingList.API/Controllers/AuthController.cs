using Microsoft.AspNetCore.Mvc;
using ShoppingList.API.DTOs;
using ShoppingList.API.Services.Interfaces;

namespace ShoppingList.API.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
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
	}
}
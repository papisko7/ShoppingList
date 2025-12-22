using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs.Login
{
	public class LoginDto
	{
		[Required]
		public required string Username { get; set; }

		[Required(ErrorMessage = "Password is required.")]
		public required string Password { get; set; }
	}
}
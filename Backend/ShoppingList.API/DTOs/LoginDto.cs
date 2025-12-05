using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs
{
	public class LoginDto
	{
		[Required]
		[EmailAddress]
		public required string Email { get; set; }

		[Required(ErrorMessage = "Password is required.")]
		public required string Password { get; set; }
	}
}
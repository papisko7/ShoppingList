using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs
{
	public class RegisterDto
	{
		[Required(ErrorMessage = "Username is required.")]
		[MinLength(4, ErrorMessage = "Username must be at least 4 characters long.")]
		public required string Username { get; set; }

		[Required(ErrorMessage = "Email is required.")]
		[EmailAddress(ErrorMessage = "Invalid Email Address")]
		public required string Email { get; set; }

		[Required(ErrorMessage = "Password is required.")]
		[MinLength(8, ErrorMessage = "Password must be at least 8 characters long.")]
		[RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z]).{8,}$",
			ErrorMessage = "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.")]
		public required string Password { get; set; }
	}
}
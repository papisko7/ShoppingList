using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs.Logic.Group
{
	public class JoinGroupDto
	{
		[Required]
		[StringLength(10, MinimumLength = 5, ErrorMessage = "Join code must be valid.")]
		public string JoinCode { get; set; } = string.Empty;
	}
}
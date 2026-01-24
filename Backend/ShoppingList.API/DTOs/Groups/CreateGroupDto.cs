using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs.Logic.Group
{
	public class CreateGroupDto
	{
		[Required]
		[StringLength(100, MinimumLength = 3, ErrorMessage = "Group name must be between 3 and 100 characters.")]
		public string Name { get; set; } = string.Empty;
	}
}
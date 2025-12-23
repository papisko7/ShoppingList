using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs.Logic.List
{
	public class CreateShoppingListDto
	{
		[Required]
		[StringLength(100, MinimumLength = 1, ErrorMessage = "Attribute name {Name} length has to be between 1 to 100 characters.")]
		public required string Name { get; set; }

		public int? GroupId { get; set; }
	}
}
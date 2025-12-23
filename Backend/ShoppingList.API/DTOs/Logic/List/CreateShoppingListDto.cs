using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs.Logic.List
{
	public class CreateShoppingListDto
	{
		[Required]
		public required string Name { get; set; }
	}
}

using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs.Logic
{
	public class CreateShoppingListDto
	{
		[Required]
		public required string Name { get; set; }
	}
}

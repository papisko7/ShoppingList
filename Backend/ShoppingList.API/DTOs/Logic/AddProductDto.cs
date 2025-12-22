using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs.Logic
{
	public class AddProductDto
	{
		[Required]
		public int ShoppingListId { get; set; }

		[Required]
		public required string ProductName { get; set; }

		public string Quantity { get; set; } = "1";

		public string CategoryName { get; set; } = "General";
	}
}
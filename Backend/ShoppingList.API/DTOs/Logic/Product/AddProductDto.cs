using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs.Logic.Product
{
	public class AddProductDto
	{
		[Required]
		public int ShoppingListId { get; set; }

		[Required]
		[StringLength(100, MinimumLength = 1, ErrorMessage = "Attribute name {ProductName} has to have a length of 1 to 100.")]
		public required string ProductName { get; set; }

		[StringLength(50, MinimumLength = 1, ErrorMessage = "Attribute name {Quantity} has to have a length of 1 to 50.")]
		public string Quantity { get; set; } = "1";

		public string CategoryName { get; set; } = "Uncategorized";
	}
}
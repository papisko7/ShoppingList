namespace ShoppingList.API.DTOs.Logic
{
	public class ShoppingListItemDto
	{
		public int Id { get; set; }

		public int ProductId { get; set; }

		public string ProductName { get; set; } = string.Empty;

		public string CategoryName { get; set; } = string.Empty;

		public string Quantity { get; set; } = "1";

		public bool IsBought { get; set; }
	}
}
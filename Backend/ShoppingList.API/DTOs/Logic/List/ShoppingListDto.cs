using ShoppingList.API.DTOs.Logic.Item;

namespace ShoppingList.API.DTOs.Logic.List
{
	public class ShoppingListDto
	{
		public int Id { get; set; }

		public required string Name { get; set; }

		public DateTime CreatedAt { get; set; }

		public List<ShoppingListItemDto> Items { get; set; } = new();
	}
}
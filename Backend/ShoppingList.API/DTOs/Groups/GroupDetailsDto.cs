using ShoppingList.API.DTOs.Logic.List;

namespace ShoppingList.API.DTOs.Logic.Group
{
	public class GroupDetailsDto
	{
		public int Id { get; set; }

		public string Name { get; set; } = string.Empty;

		public string JoinCode { get; set; } = string.Empty;

		public List<string> Members { get; set; } = new();

		public List<ShoppingListDto> Lists { get; set; } = new();
	}
}
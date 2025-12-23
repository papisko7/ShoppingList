using ShoppingList.API.DTOs.Logic.Item;
using ShoppingList.API.DTOs.Logic.List;
using ShoppingList.API.DTOs.Logic.Product;

namespace ShoppingList.API.Services
{
	public interface IListService
	{
		Task<List<ShoppingListDto>> GetAllListsAsync(int userId);

		Task<ShoppingListDto?> GetListByIdAsync(int listId, int userId);

		Task<ShoppingListDto> CreateListAsync(CreateShoppingListDto dto, int userId);

		Task DeleteListAsync(int listId, int userId);

		Task<ShoppingListItemDto> AddItemAsync(AddProductDto dto, int userId);

		Task ToggleItemAsync(int itemId, int userId);

		Task RemoveItemAsync(int itemId, int userId);
	}
}
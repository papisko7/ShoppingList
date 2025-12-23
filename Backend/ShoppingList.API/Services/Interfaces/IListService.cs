using ShoppingList.API.DTOs.Logic.Item;
using ShoppingList.API.DTOs.Logic.List;
using ShoppingList.API.DTOs.Logic.Product;

namespace ShoppingList.API.Services
{
	public interface IListService
	{
		public Task<List<ShoppingListDto>> GetAllListsAsync(int userId);

		public Task<ShoppingListDto?> GetListByIdAsync(int listId, int userId);

		public Task<ShoppingListDto> CreateListAsync(CreateShoppingListDto dto, int userId);

		public Task UpdateListAsync(int listId, UpdateListDto dto, int userId);

		public Task DeleteListAsync(int listId, int userId);

		public Task<ShoppingListItemDto> AddItemAsync(AddProductDto dto, int userId);

		public Task<ShoppingListItemDto?> GetItemByIdAsync(int itemId, int userId);

		public Task UpdateItemAsync(int itemId, UpdateListItemDto dto, int userId);

		public Task ToggleItemAsync(int itemId, int userId);

		public Task RemoveItemAsync(int itemId, int userId);
	}
}
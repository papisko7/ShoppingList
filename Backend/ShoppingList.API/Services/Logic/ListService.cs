using Microsoft.EntityFrameworkCore;
using ShoppingList.API.DTOs.Logic;
using ShoppingList.Data.Database;
using ShoppingList.Data.Entities.Logic;

namespace ShoppingList.API.Services
{
	public class ListService : IListService
	{
		private readonly ShoppingListDbContext _context;

		public ListService(ShoppingListDbContext context)
		{
			_context = context;
		}

		public async Task<List<ShoppingListDto>> GetAllListsAsync(int userId)
		{
			return await _context.ShoppingLists
				.Where(l => l.UserId == userId)
				.Select(l => new ShoppingListDto
				{
					Id = l.Id,
					Name = l.Name,
					CreatedAt = l.CreatedAt,
				})
				.ToListAsync();
		}

		public async Task<ShoppingListDto?> GetListByIdAsync(int listId, int userId)
		{
			var list = await _context.ShoppingLists
				.Include(l => l.Items).ThenInclude(i => i.Product).ThenInclude(p => p.Category)
				.FirstOrDefaultAsync(l => l.Id == listId && l.UserId == userId);

			if (list == null) return null;

			return new ShoppingListDto
			{
				Id = list.Id,
				Name = list.Name,
				CreatedAt = list.CreatedAt,
				Items = list.Items.Select(i => new ShoppingListItemDto
				{
					Id = i.Id,
					ProductId = i.ProductId,
					ProductName = i.Product!.Name,
					CategoryName = i.Product.Category?.Name ?? "Uncategorized",
					Quantity = i.Quantity,
					IsBought = i.IsBought
				}).ToList()
			};
		}

		public async Task<ShoppingListDto> CreateListAsync(CreateShoppingListDto dto, int userId)
		{
			var newList = new ShoppingListEntity
			{
				Name = dto.Name,
				UserId = userId,
				CreatedAt = DateTime.UtcNow
			};

			_context.ShoppingLists.Add(newList);
			await _context.SaveChangesAsync();

			return new ShoppingListDto { Id = newList.Id, Name = newList.Name, CreatedAt = newList.CreatedAt };
		}

		public async Task DeleteListAsync(int listId, int userId)
		{
			var list = await _context.ShoppingLists.FirstOrDefaultAsync(l => l.Id == listId && l.UserId == userId);
			if (list != null)
			{
				_context.ShoppingLists.Remove(list);
				await _context.SaveChangesAsync();
			}
		}

		public async Task<ShoppingListItemDto> AddItemAsync(AddProductDto dto, int userId)
		{
			var list = await _context.ShoppingLists.FirstOrDefaultAsync(l => l.Id == dto.ShoppingListId && l.UserId == userId);
			if (list == null)
			{
				throw new Exception("List not found.");
			}

			var category = await _context.ProductCategories.FirstOrDefaultAsync(c => c.Name == dto.CategoryName);
			if (category == null)
			{
				category = new ProductCategoryEntity { Name = dto.CategoryName };
				_context.ProductCategories.Add(category);
				await _context.SaveChangesAsync();
			}

			var product = await _context.Products.FirstOrDefaultAsync(p => p.Name == dto.ProductName);
			if (product == null)
			{
				product = new ProductEntity { Name = dto.ProductName, CategoryId = category.Id };
				_context.Products.Add(product);
				await _context.SaveChangesAsync();
			}

			var newItem = new ShoppingListItemEntity
			{
				ShoppingListId = list.Id,
				ProductId = product.Id,
				Quantity = dto.Quantity,
				IsBought = false
			};

			_context.ShoppingListItems.Add(newItem);
			await _context.SaveChangesAsync();

			return new ShoppingListItemDto
			{
				Id = newItem.Id,
				ProductId = product.Id,
				ProductName = product.Name,
				CategoryName = category.Name,
				Quantity = newItem.Quantity,
				IsBought = false
			};
		}

		public async Task ToggleItemAsync(int itemId, int userId)
		{
			var item = await _context.ShoppingListItems
				.Include(i => i.ShoppingList)
				.FirstOrDefaultAsync(i => i.Id == itemId && i.ShoppingList!.UserId == userId);

			if (item != null)
			{
				item.IsBought = !item.IsBought;
				await _context.SaveChangesAsync();
			}
		}

		public async Task RemoveItemAsync(int itemId, int userId)
		{
			var item = await _context.ShoppingListItems
				.Include(i => i.ShoppingList)
				.FirstOrDefaultAsync(i => i.Id == itemId && i.ShoppingList!.UserId == userId);

			if (item != null)
			{
				_context.ShoppingListItems.Remove(item);
				await _context.SaveChangesAsync();
			}
		}
	}
}
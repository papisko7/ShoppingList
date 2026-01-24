using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using ShoppingList.API.DTOs.Logic.Item;
using ShoppingList.API.DTOs.Logic.List;
using ShoppingList.API.DTOs.Logic.Product;
using ShoppingList.API.Hubs;
using ShoppingList.Data.Database;
using ShoppingList.Data.Entities.Logic;

namespace ShoppingList.API.Services
{
	public class ListService : IListService
	{
		private readonly ShoppingListDbContext _context;
		private readonly IHubContext<ShoppingHub> _hubContext;
		private const string DEFAULT_CATEGORY = "Uncategorized";

		public ListService(ShoppingListDbContext context, IHubContext<ShoppingHub> hubContext)
		{
			_context = context;
			_hubContext = hubContext;
		}

		private async Task NotifyGroupAsync(int? groupId, string message)
		{
			if (groupId != null)
			{
				await _hubContext.Clients.Group(groupId.ToString()!)
					.SendAsync("ReceiveListUpdate", message);
			}
		}

		private async Task ValidateGroupMembershipAsync(int groupId, int userId)
		{
			bool isMember = await _context.GroupMembers
				.AnyAsync(m => m.GroupId == groupId && m.UserId == userId);

			if (!isMember)
			{
				throw new UnauthorizedAccessException("You are not a member of this group.");
			}
		}

		public async Task<List<ShoppingListDto>> GetAllListsAsync(int userId)
		{
			return await _context.ShoppingLists
				.Where(l => l.UserId == userId || (l.GroupId != null && l.Group!.Members.Any(m => m.UserId == userId)))
				.Select(l => new ShoppingListDto
				{
					Id = l.Id,
					Name = l.Name,
					CreatedAt = l.CreatedAt,
				})
				.OrderByDescending(l => l.CreatedAt)
				.ToListAsync();
		}

		public async Task<ShoppingListDto?> GetListByIdAsync(int listId, int userId)
		{
			var list = await _context.ShoppingLists
				.Include(l => l.Items).ThenInclude(i => i.Product).ThenInclude(p => p.Category)
				.Include(l => l.Group).ThenInclude(g => g!.Members)
				.FirstOrDefaultAsync(l => l.Id == listId);

			if (list == null)
			{
				throw new KeyNotFoundException("List not found.");
			}

			bool hasAccess = list.UserId == userId ||
							 (list.GroupId != null && list.Group!.Members.Any(m => m.UserId == userId));

			if (!hasAccess)
			{
				throw new UnauthorizedAccessException("You do not have access to this list.");
			}

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
					CategoryName = i.Product.Category?.Name ?? DEFAULT_CATEGORY,
					Quantity = i.Quantity,
					IsBought = i.IsBought
				}).ToList()
			};
		}

		public async Task<ShoppingListDto> CreateListAsync(CreateShoppingListDto dto, int userId)
		{
			if (string.IsNullOrWhiteSpace(dto.Name))
			{
				throw new ArgumentException("Name of list cannot be empty.");
			}

			if (dto.GroupId.HasValue)
			{
				await ValidateGroupMembershipAsync(dto.GroupId.Value, userId);
			}

			var newList = new ShoppingListEntity
			{
				Name = dto.Name,
				UserId = userId,
				GroupId = dto.GroupId,
				CreatedAt = DateTime.UtcNow
			};

			_context.ShoppingLists.Add(newList);
			await _context.SaveChangesAsync();
			await NotifyGroupAsync(newList.GroupId, "New list created");

			return new ShoppingListDto { Id = newList.Id, Name = newList.Name, CreatedAt = newList.CreatedAt };
		}

		public async Task UpdateListAsync(int listId, UpdateListDto dto, int userId)
		{
			var list = await _context.ShoppingLists
				.Include(l => l.Group).ThenInclude(g => g!.Members)
				.FirstOrDefaultAsync(l => l.Id == listId);

			if (list == null)
			{
				throw new KeyNotFoundException("List not found.");
			}

			bool hasAccess = list.UserId == userId || (list.GroupId != null && list.Group!.Members.Any(m => m.UserId == userId));

			if (!hasAccess)
			{
				throw new UnauthorizedAccessException("Access denied.");
			}

			if (string.IsNullOrWhiteSpace(dto.Name))
			{
				throw new ArgumentException("Name cannot be empty.");
			}

			list.Name = dto.Name;
			await _context.SaveChangesAsync();
			await NotifyGroupAsync(list.GroupId, "List renamed");
		}

		public async Task DeleteListAsync(int listId, int userId)
		{
			var list = await _context.ShoppingLists
				.Include(l => l.Group).ThenInclude(g => g!.Members)
				.FirstOrDefaultAsync(l => l.Id == listId);

			if (list == null)
			{
				throw new KeyNotFoundException("List not found.");
			}

			bool hasAccess = list.UserId == userId || (list.GroupId != null && list.Group!.Members.Any(m => m.UserId == userId));
			if (!hasAccess)
			{
				throw new UnauthorizedAccessException("Access denied.");
			}

			int? groupId = list.GroupId;

			_context.ShoppingLists.Remove(list);
			await _context.SaveChangesAsync();
			await NotifyGroupAsync(groupId, "List deleted");
		}

		public async Task<ShoppingListItemDto> AddItemAsync(AddProductDto dto, int userId)
		{
			if (string.IsNullOrWhiteSpace(dto.ProductName))
			{
				throw new ArgumentException("Product name cannot be empty.");
			}

			if (string.IsNullOrWhiteSpace(dto.CategoryName))
			{
				dto.CategoryName = DEFAULT_CATEGORY;
			}

			var list = await _context.ShoppingLists
				.Include(l => l.Group).ThenInclude(g => g!.Members)
				.FirstOrDefaultAsync(l => l.Id == dto.ShoppingListId);

			if (list == null)
			{
				throw new KeyNotFoundException("List not found.");
			}

			bool hasAccess = list.UserId == userId || (list.GroupId != null && list.Group!.Members.Any(m => m.UserId == userId));

			if (!hasAccess)
			{
				throw new UnauthorizedAccessException("Access denied.");
			}

			var category = await _context.ProductCategories.FirstOrDefaultAsync(c => c.Name.ToLower() == dto.CategoryName.ToLower());

			if (category == null)
			{
				category = new ProductCategoryEntity { Name = dto.CategoryName };

				try
				{
					_context.ProductCategories.Add(category);
					await _context.SaveChangesAsync();
				}

				catch (DbUpdateException)
				{
					_context.Entry(category).State = EntityState.Detached;
					category = await _context.ProductCategories.FirstAsync(c => c.Name.ToLower() == dto.CategoryName.ToLower());
				}
			}

			var product = await _context.Products.FirstOrDefaultAsync(p => p.Name.ToLower() == dto.ProductName.ToLower());

			if (product == null)
			{
				product = new ProductEntity { Name = dto.ProductName, CategoryId = category.Id };

				try
				{
					_context.Products.Add(product);
					await _context.SaveChangesAsync();
				}

				catch (DbUpdateException)
				{
					_context.Entry(product).State = EntityState.Detached;
					product = await _context.Products.FirstAsync(p => p.Name.ToLower() == dto.ProductName.ToLower());
				}
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
			await NotifyGroupAsync(list.GroupId, "Item added");

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

		private async Task<ShoppingListItemEntity> GetItemWithAccessCheckAsync(int itemId, int userId)
		{
			var item = await _context.ShoppingListItems
				.Include(i => i.ShoppingList).ThenInclude(l => l!.Group).ThenInclude(g => g!.Members)
				.Include(i => i.Product).ThenInclude(p => p!.Category)
				.FirstOrDefaultAsync(i => i.Id == itemId);

			if (item == null)
			{
				throw new KeyNotFoundException("Item not found.");
			}

			var list = item.ShoppingList;
			bool hasAccess = list!.UserId == userId || (list.GroupId != null && list.Group!.Members.Any(m => m.UserId == userId));

			if (!hasAccess)
			{
				throw new UnauthorizedAccessException("Access denied.");
			}

			return item;
		}

		public async Task<ShoppingListItemDto?> GetItemByIdAsync(int itemId, int userId)
		{
			var item = await GetItemWithAccessCheckAsync(itemId, userId);

			return new ShoppingListItemDto
			{
				Id = item.Id,
				ProductId = item.ProductId,
				ProductName = item.Product!.Name,
				CategoryName = item.Product.Category?.Name ?? DEFAULT_CATEGORY,
				Quantity = item.Quantity,
				IsBought = item.IsBought
			};
		}

		public async Task UpdateItemAsync(int itemId, UpdateListItemDto dto, int userId)
		{
			var item = await GetItemWithAccessCheckAsync(itemId, userId);

			item.Quantity = dto.Quantity;
			await _context.SaveChangesAsync();
			await NotifyGroupAsync(item.ShoppingList!.GroupId, "Item updated");
		}

		public async Task ToggleItemAsync(int itemId, int userId)
		{
			var item = await GetItemWithAccessCheckAsync(itemId, userId);

			item.IsBought = !item.IsBought;
			await _context.SaveChangesAsync();
			await NotifyGroupAsync(item.ShoppingList!.GroupId, "Item toggled");
		}

		public async Task RemoveItemAsync(int itemId, int userId)
		{
			var item = await GetItemWithAccessCheckAsync(itemId, userId);

			_context.ShoppingListItems.Remove(item);
			await _context.SaveChangesAsync();
			await NotifyGroupAsync(item.ShoppingList!.GroupId, "Item removed");
		}
	}
}
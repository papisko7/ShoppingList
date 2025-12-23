using Microsoft.EntityFrameworkCore;
using ShoppingList.API.DTOs.Logic;
using ShoppingList.API.DTOs.Logic.Category;
using ShoppingList.API.DTOs.Logic.Product;
using ShoppingList.API.Services.Interfaces;
using ShoppingList.Data.Database;
using ShoppingList.Data.Entities.Logic;

namespace ShoppingList.API.Services.Logic
{
	public class ProductService : IProductService
	{
		private readonly ShoppingListDbContext _context;

		public ProductService(ShoppingListDbContext context)
		{
			_context = context;
		}

		// --- PRODUKTY ---

		public async Task<List<ProductDto>> GetAllProductsAsync()
		{
			return await _context.Products
				.Include(p => p.Category)
				.Select(p => new ProductDto
				{
					Id = p.Id,
					Name = p.Name,
					CategoryId = p.CategoryId,
					CategoryName = p.Category.Name
				})
				.OrderBy(p => p.Name)
				.ToListAsync();
		}

		public async Task<ProductDto?> GetProductByIdAsync(int id)
		{
			var p = await _context.Products.Include(c => c.Category).FirstOrDefaultAsync(x => x.Id == id);
			if (p == null) return null;

			return new ProductDto
			{
				Id = p.Id,
				Name = p.Name,
				CategoryId = p.CategoryId,
				CategoryName = p.Category.Name
			};
		}

		public async Task UpdateProductAsync(int id, UpdateProductDto dto)
		{
			var product = await _context.Products.FindAsync(id);
			if (product == null) throw new Exception("Product not found.");

			// Sprawdź czy kategoria istnieje
			var categoryExists = await _context.ProductCategories.AnyAsync(c => c.Id == dto.CategoryId);
			if (!categoryExists) throw new Exception("Category does not exist.");

			product.Name = dto.Name;
			product.CategoryId = dto.CategoryId;

			try
			{
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateException)
			{
				throw new Exception("Product with this name already exists.");
			}
		}

		public async Task DeleteProductAsync(int id)
		{
			var product = await _context.Products.FindAsync(id);
			if (product == null) throw new Exception("Product not found.");

			// VALIDATION: Nie usuwaj, jeśli jest na jakiejś liście zakupów!
			bool isUsed = await _context.ShoppingListItems.AnyAsync(i => i.ProductId == id);
			if (isUsed)
			{
				throw new Exception("Cannot delete product because it is used in one or more shopping lists.");
			}

			_context.Products.Remove(product);
			await _context.SaveChangesAsync();
		}

		// --- KATEGORIE ---

		public async Task<List<CategoryDto>> GetAllCategoriesAsync()
		{
			return await _context.ProductCategories
				.Select(c => new CategoryDto { Id = c.Id, Name = c.Name })
				.OrderBy(c => c.Name)
				.ToListAsync();
		}

		public async Task<CategoryDto?> GetCategoryByIdAsync(int id)
		{
			var c = await _context.ProductCategories.FindAsync(id);
			return c == null ? null : new CategoryDto { Id = c.Id, Name = c.Name };
		}

		public async Task<CategoryDto> CreateCategoryAsync(UpdateCategoryDto dto)
		{
			var category = new ProductCategoryEntity { Name = dto.Name };
			try
			{
				_context.ProductCategories.Add(category);
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateException)
			{
				throw new Exception("Category already exists.");
			}
			return new CategoryDto { Id = category.Id, Name = category.Name };
		}

		public async Task UpdateCategoryAsync(int id, UpdateCategoryDto dto)
		{
			var category = await _context.ProductCategories.FindAsync(id);
			if (category == null) throw new Exception("Category not found.");

			category.Name = dto.Name;

			try
			{
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateException)
			{
				throw new Exception("Category with this name already exists.");
			}
		}

		public async Task DeleteCategoryAsync(int id)
		{
			var category = await _context.ProductCategories.FindAsync(id);
			if (category == null) throw new Exception("Category not found.");

			// VALIDATION: Nie usuwaj, jeśli kategoria ma produkty!
			bool hasProducts = await _context.Products.AnyAsync(p => p.CategoryId == id);
			if (hasProducts)
			{
				throw new Exception("Cannot delete category because it contains products. Move or delete products first.");
			}

			_context.ProductCategories.Remove(category);
			await _context.SaveChangesAsync();
		}
	}
}
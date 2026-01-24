using Microsoft.EntityFrameworkCore;
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
		private const string DEFAULT_CATEGORY = "Uncategorized";

		public ProductService(ShoppingListDbContext context)
		{
			_context = context;
		}

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

		public async Task<ProductDto> CreateProductAsync(CreateProductDictionaryDto dto)
		{
			var categoryExists = await _context.ProductCategories.AnyAsync(c => c.Id == dto.CategoryId);

			if (!categoryExists)
			{
				throw new ArgumentException("Category does not exist.");
			}

			var product = new ProductEntity
			{
				Name = dto.Name,
				CategoryId = dto.CategoryId
			};

			try
			{
				_context.Products.Add(product);
				await _context.SaveChangesAsync();
			}

			catch (DbUpdateException)
			{
				throw new InvalidOperationException("Product with this name already exists.");
			}

			var categoryName = await _context.ProductCategories
				.Where(c => c.Id == dto.CategoryId)
				.Select(c => c.Name)
				.FirstOrDefaultAsync();

			return new ProductDto
			{
				Id = product.Id,
				Name = product.Name,
				CategoryId = product.CategoryId,
				CategoryName = categoryName ?? DEFAULT_CATEGORY
			};
		}

		public async Task<ProductDto?> GetProductByIdAsync(int id)
		{
			var p = await _context.Products.Include(c => c.Category).FirstOrDefaultAsync(x => x.Id == id);

			if (p == null)
			{
				throw new KeyNotFoundException("Product not found.");
			}

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

			if (product == null)
			{
				throw new KeyNotFoundException("Product not found.");
			}

			var categoryExists = await _context.ProductCategories.AnyAsync(c => c.Id == dto.CategoryId);

			if (!categoryExists)
			{
				throw new ArgumentException("Category does not exist.");
			}

			product.Name = dto.Name;
			product.CategoryId = dto.CategoryId;

			try
			{
				await _context.SaveChangesAsync();
			}

			catch (DbUpdateException)
			{
				throw new InvalidOperationException("Product with this name already exists.");
			}
		}

		public async Task DeleteProductAsync(int id)
		{
			var product = await _context.Products.FindAsync(id);

			if (product == null)
			{
				throw new KeyNotFoundException("Product not found.");
			}

			bool isUsed = await _context.ShoppingListItems.AnyAsync(i => i.ProductId == id);

			if (isUsed)
			{
				throw new InvalidOperationException("Cannot delete product because it is used in shopping lists.");
			}

			_context.Products.Remove(product);
			await _context.SaveChangesAsync();
		}

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

			if (c == null)
			{
				throw new KeyNotFoundException("Category not found.");
			}

			return new CategoryDto
			{
				Id = c.Id,
				Name = c.Name
			};
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
				throw new InvalidOperationException("Category with this name already exists.");
			}

			return new CategoryDto
			{
				Id = category.Id,
				Name = category.Name
			};
		}

		public async Task UpdateCategoryAsync(int id, UpdateCategoryDto dto)
		{
			var category = await _context.ProductCategories.FindAsync(id);

			if (category == null)
			{
				throw new KeyNotFoundException("Category not found.");
			}

			category.Name = dto.Name;

			try
			{
				await _context.SaveChangesAsync();
			}

			catch (DbUpdateException)
			{
				throw new InvalidOperationException("Category with this name already exists.");
			}
		}

		public async Task DeleteCategoryAsync(int id)
		{
			var category = await _context.ProductCategories.FindAsync(id);

			if (category == null)
			{
				throw new KeyNotFoundException("Category not found.");
			}

			bool hasProducts = await _context.Products.AnyAsync(p => p.CategoryId == id);

			if (hasProducts)
			{
				throw new InvalidOperationException("Cannot delete category because it contains products. Move or delete products first.");
			}

			_context.ProductCategories.Remove(category);
			await _context.SaveChangesAsync();
		}
	}
}
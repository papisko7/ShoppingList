using ShoppingList.API.DTOs.Logic.Category;
using ShoppingList.API.DTOs.Logic.Product;

namespace ShoppingList.API.Services.Interfaces
{
	public interface IProductService
	{
		public Task<List<ProductDto>> GetAllProductsAsync();

		public Task<ProductDto?> GetProductByIdAsync(int id);

		public Task<ProductDto> CreateProductAsync(CreateProductDictionaryDto dto);

		public Task UpdateProductAsync(int id, UpdateProductDto dto);

		public Task DeleteProductAsync(int id);

		public Task<List<CategoryDto>> GetAllCategoriesAsync();

		public Task<CategoryDto?> GetCategoryByIdAsync(int id);

		public Task<CategoryDto> CreateCategoryAsync(UpdateCategoryDto dto);

		public Task UpdateCategoryAsync(int id, UpdateCategoryDto dto);

		public Task DeleteCategoryAsync(int id);
	}
}
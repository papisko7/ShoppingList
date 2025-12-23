using ShoppingList.API.DTOs.Logic.Category;
using ShoppingList.API.DTOs.Logic.Product;

namespace ShoppingList.API.Services.Interfaces
{
    public interface IProductService
    {
		Task<List<ProductDto>> GetAllProductsAsync();

		Task<ProductDto?> GetProductByIdAsync(int id);

		Task UpdateProductAsync(int id, UpdateProductDto dto);

		Task DeleteProductAsync(int id);

		Task<List<CategoryDto>> GetAllCategoriesAsync();

		Task<CategoryDto?> GetCategoryByIdAsync(int id);

		Task<CategoryDto> CreateCategoryAsync(UpdateCategoryDto dto);

		Task UpdateCategoryAsync(int id, UpdateCategoryDto dto);

		Task DeleteCategoryAsync(int id);
	}
}
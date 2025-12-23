using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ShoppingList.API.DTOs.Logic.Product;
using ShoppingList.API.Services.Interfaces;

namespace ShoppingList.API.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	[Authorize]
	public class ProductsController : ControllerBase
	{
		private readonly IProductService _service;

		public ProductsController(IProductService service)
		{
			_service = service;
		}

		[HttpPost("create-product")]
		public async Task<ActionResult<ProductDto>> Create([FromBody] CreateProductDictionaryDto dto)
		{
			var result = await _service.CreateProductAsync(dto);
			return CreatedAtAction(nameof(GetById), new { id = result.Id }, result);
		}

		[HttpGet("get-all-products")]
		public async Task<ActionResult<List<ProductDto>>> GetAll()
		{
			return Ok(await _service.GetAllProductsAsync());
		}

		[HttpGet("get-product-by-id/{id}")]
		public async Task<ActionResult<ProductDto>> GetById(int id)
		{
			var prod = await _service.GetProductByIdAsync(id);

			if (prod == null)
			{
				return NotFound();
			}

			return Ok(prod);
		}

		[HttpPut("update-product/{id}")]
		public async Task<IActionResult> Update(int id, [FromBody] UpdateProductDto dto)
		{
			await _service.UpdateProductAsync(id, dto);
			return Ok(new { message = "Product updated" });
		}

		[HttpDelete("delete-product/{id}")]
		public async Task<IActionResult> Delete(int id)
		{
			await _service.DeleteProductAsync(id);
			return Ok(new { message = "Product deleted from dictionary" });
		}
	}
}
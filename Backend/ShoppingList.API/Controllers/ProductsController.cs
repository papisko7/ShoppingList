using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ShoppingList.API.DTOs.Logic;
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

		[HttpGet("GetAllProducts")]
		public async Task<ActionResult<List<ProductDto>>> GetAll()
		{
			return Ok(await _service.GetAllProductsAsync());
		}

		[HttpGet("GetProductById/{id}")]
		public async Task<ActionResult<ProductDto>> GetById(int id)
		{
			var prod = await _service.GetProductByIdAsync(id);
			if (prod == null) return NotFound();
			return Ok(prod);
		}

		// UWAGA: CreateProduct nie jest tu konieczne, bo robimy "FindOrCreate" w ListService,
		// ale jeśli chcesz ręcznie dodać produkt do słownika, można to dopisać w serwisie.
		// Tutaj skupiamy się na UPDATE i DELETE.

		[HttpPut("UpdateProduct/{id}")]
		public async Task<IActionResult> Update(int id, [FromBody] UpdateProductDto dto)
		{
			try
			{
				await _service.UpdateProductAsync(id, dto);
				return Ok(new { message = "Product updated" });
			}
			catch (Exception ex)
			{
				return BadRequest(new { message = ex.Message });
			}
		}

		[HttpDelete("DeleteProduct/{id}")]
		public async Task<IActionResult> Delete(int id)
		{
			try
			{
				await _service.DeleteProductAsync(id);
				return Ok(new { message = "Product deleted from dictionary" });
			}
			catch (Exception ex)
			{
				return BadRequest(new { message = ex.Message }); // Zwróci info, że produkt jest na liście zakupów
			}
		}
	}
}
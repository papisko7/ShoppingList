using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ShoppingList.API.DTOs.Logic.Category;
using ShoppingList.API.Services.Interfaces;

namespace ShoppingList.API.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	[Authorize]
	public class CategoriesController : ControllerBase
	{
		private readonly IProductService _service;

		public CategoriesController(IProductService service)
		{
			_service = service;
		}

		[HttpGet("get-all-categories")]
		public async Task<ActionResult<List<CategoryDto>>> GetAll()
		{
			return Ok(await _service.GetAllCategoriesAsync());
		}

		[HttpGet("get-category-by-id/{id}")]
		public async Task<ActionResult<CategoryDto>> GetById(int id)
		{
			var cat = await _service.GetCategoryByIdAsync(id);

			if (cat == null)
			{
				return NotFound();
			}

			return Ok(cat);
		}

		[HttpPost("create-category")]
		public async Task<ActionResult<CategoryDto>> Create([FromBody] UpdateCategoryDto dto)
		{
			var result = await _service.CreateCategoryAsync(dto);
			return CreatedAtAction(nameof(GetById), new { id = result.Id }, result);
		}

		[HttpPut("update-category/{id}")]
		public async Task<IActionResult> Update(int id, [FromBody] UpdateCategoryDto dto)
		{
			await _service.UpdateCategoryAsync(id, dto);
			return Ok(new { message = "Category updated" });
		}

		[HttpDelete("delete-category/{id}")]
		public async Task<IActionResult> Delete(int id)
		{
			await _service.DeleteCategoryAsync(id);
			return Ok(new { message = "Category deleted" });
		}
	}
}
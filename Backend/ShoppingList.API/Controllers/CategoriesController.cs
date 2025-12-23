using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ShoppingList.API.DTOs.Logic;
using ShoppingList.API.DTOs.Logic.Category;
using ShoppingList.API.Services.Interfaces;

namespace ShoppingList.API.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	[Authorize] // Tylko zalogowani mogą zarządzać słownikiem
	public class CategoriesController : ControllerBase
	{
		private readonly IProductService _service;

		public CategoriesController(IProductService service)
		{
			_service = service;
		}

		[HttpGet("GetAllCategories")]
		public async Task<ActionResult<List<CategoryDto>>> GetAll()
		{
			return Ok(await _service.GetAllCategoriesAsync());
		}

		[HttpGet("GetCategoryById/{id}")]
		public async Task<ActionResult<CategoryDto>> GetById(int id)
		{
			var cat = await _service.GetCategoryByIdAsync(id);
			if (cat == null) return NotFound();
			return Ok(cat);
		}

		[HttpPost("CreateCategory")]
		public async Task<ActionResult<CategoryDto>> Create([FromBody] UpdateCategoryDto dto)
		{
			try
			{
				var result = await _service.CreateCategoryAsync(dto);
				return CreatedAtAction(nameof(GetById), new { id = result.Id }, result);
			}
			catch (Exception ex)
			{
				return BadRequest(new { message = ex.Message });
			}
		}

		[HttpPut("UpdateCategory/{id}")]
		public async Task<IActionResult> Update(int id, [FromBody] UpdateCategoryDto dto)
		{
			try
			{
				await _service.UpdateCategoryAsync(id, dto);
				return Ok(new { message = "Category updated" });
			}
			catch (Exception ex)
			{
				return BadRequest(new { message = ex.Message });
			}
		}

		[HttpDelete("DeleteCategory/{id}")]
		public async Task<IActionResult> Delete(int id)
		{
			try
			{
				await _service.DeleteCategoryAsync(id);
				return Ok(new { message = "Category deleted" });
			}
			catch (Exception ex)
			{
				return BadRequest(new { message = ex.Message }); // Zwróci info, że nie można usunąć bo są produkty
			}
		}
	}
}
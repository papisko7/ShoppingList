using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ShoppingList.API.DTOs.Logic.Item;
using ShoppingList.API.DTOs.Logic.Product;
using ShoppingList.API.Services;

namespace ShoppingList.API.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	[Authorize]
	public class ListItemsController : ControllerBase
	{
		private readonly IListService _listService;

		public ListItemsController(IListService listService)
		{
			_listService = listService;
		}

		private int GetUserId()
		{
			var idClaim = User.FindFirst("UserId");

			if (idClaim == null)
			{
				return 0;
			}

			return int.Parse(idClaim.Value);
		}

		[HttpPost("add-item")]
		public async Task<ActionResult<ShoppingListItemDto>> AddItem([FromBody] AddProductDto dto)
		{
			var item = await _listService.AddItemAsync(dto, GetUserId());
			return CreatedAtAction(nameof(GetItem), new { id = item.Id }, item);
		}

		[HttpGet("get-item/{id}")]
		public async Task<ActionResult<ShoppingListItemDto>> GetItem(int id)
		{
			var item = await _listService.GetItemByIdAsync(id, GetUserId());
			return Ok(item);
		}

		[HttpPut("update-item/{id}")]
		public async Task<IActionResult> UpdateItem(int id, [FromBody] UpdateListItemDto dto)
		{
			await _listService.UpdateItemAsync(id, dto, GetUserId());
			return Ok(new { message = "Item updated" });
		}

		[HttpPatch("toggle-item/{id}")]
		public async Task<IActionResult> ToggleItem(int id)
		{
			await _listService.ToggleItemAsync(id, GetUserId());
			return Ok(new { message = "Item status toggled" });
		}

		[HttpDelete("remove-item/{id}")]
		public async Task<IActionResult> RemoveItem(int id)
		{
			await _listService.RemoveItemAsync(id, GetUserId());
			return Ok(new { message = "Item removed" });
		}
	}
}
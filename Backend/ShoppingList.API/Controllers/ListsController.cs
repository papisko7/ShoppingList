using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ShoppingList.API.DTOs.Logic;
using ShoppingList.API.Services;

namespace ShoppingList.API.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	[Authorize]
	public class ListsController : ControllerBase
	{
		private readonly IListService _listService;

		public ListsController(IListService listService)
		{
			_listService = listService;
		}

		private int GetUserId()
		{
			var idClaim = User.FindFirst("UserId");
			if (idClaim == null) return 0;
			return int.Parse(idClaim.Value);
		}

		[HttpGet("GetMyLists")]
		public async Task<ActionResult<List<ShoppingListDto>>> GetMyLists()
		{
			var lists = await _listService.GetAllListsAsync(GetUserId());
			return Ok(lists);
		}

		[HttpGet("GetListDetails/{id}")]
		public async Task<ActionResult<ShoppingListDto>> GetListDetails(int id)
		{
			var list = await _listService.GetListByIdAsync(id, GetUserId());
			if (list == null)
			{
				return NotFound("List not found.");
			}

			return Ok(list);
		}

		[HttpPost("CreateList")]
		public async Task<ActionResult<ShoppingListDto>> CreateList([FromBody] CreateShoppingListDto dto)
		{
			var result = await _listService.CreateListAsync(dto, GetUserId());
			return Ok(result);
		}

		[HttpDelete("DeleteList/{id}")]
		public async Task<IActionResult> DeleteList(int id)
		{
			await _listService.DeleteListAsync(id, GetUserId());
			return Ok(new { message = "List deleted" });
		}

		[HttpPost("AddItem")]
		public async Task<IActionResult> AddItem([FromBody] AddProductDto dto)
		{
			try
			{
				var item = await _listService.AddItemAsync(dto, GetUserId());
				return Ok(item);
			}
			catch (Exception ex)
			{
				return BadRequest(new { message = ex.Message });
			}
		}

		[HttpPatch("ToggleItem/{itemId}")]
		public async Task<IActionResult> ToggleItem(int itemId)
		{
			await _listService.ToggleItemAsync(itemId, GetUserId());
			return Ok(new { message = "Item updated" });
		}

		[HttpDelete("RemoveItem/{itemId}")]
		public async Task<IActionResult> RemoveItem(int itemId)
		{
			await _listService.RemoveItemAsync(itemId, GetUserId());
			return Ok(new { message = "Item removed" });
		}
	}
}
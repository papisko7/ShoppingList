using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ShoppingList.API.DTOs.Logic.List;
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

			if (idClaim == null)
			{
				return 0;
			}

			return int.Parse(idClaim.Value);
		}

		[HttpGet("get-my-lists")]
		public async Task<ActionResult<List<ShoppingListDto>>> GetMyLists()
		{
			var lists = await _listService.GetAllListsAsync(GetUserId());
			return Ok(lists);
		}

		[HttpGet("get-list-details/{id}")]
		public async Task<ActionResult<ShoppingListDto>> GetListDetails(int id)
		{
			var list = await _listService.GetListByIdAsync(id, GetUserId());

			if (list == null)
			{
				return NotFound("List not found.");
			}

			return Ok(list);
		}

		[HttpPost("create-list")]
		public async Task<ActionResult<ShoppingListDto>> CreateList([FromBody] CreateShoppingListDto dto)
		{
			var result = await _listService.CreateListAsync(dto, GetUserId());
			return Ok(result);
		}

		[HttpPut("update-list/{id}")]
		public async Task<IActionResult> UpdateList(int id, [FromBody] UpdateListDto dto)
		{
			await _listService.UpdateListAsync(id, dto, GetUserId());
			return Ok(new { message = "List updated" });
		}

		[HttpDelete("delete-list/{id}")]
		public async Task<IActionResult> DeleteList(int id)
		{
			await _listService.DeleteListAsync(id, GetUserId());
			return Ok(new { message = "List deleted" });
		}
	}
}
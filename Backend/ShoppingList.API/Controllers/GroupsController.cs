using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ShoppingList.API.DTOs.Logic.Group;
using ShoppingList.API.Services.Interfaces;

namespace ShoppingList.API.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	[Authorize]
	public class GroupsController : ControllerBase
	{
		private readonly IGroupService _service;

		public GroupsController(IGroupService service)
		{
			_service = service;
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

		[HttpPost("create-group")]
		public async Task<ActionResult<GroupDto>> Create([FromBody] CreateGroupDto dto)
		{
			var result = await _service.CreateGroupAsync(dto, GetUserId());
			return Ok(result);
		}

		[HttpPost("join-group")]
		public async Task<ActionResult<GroupDto>> Join([FromBody] JoinGroupDto dto)
		{
			var result = await _service.JoinGroupAsync(dto, GetUserId());
			return Ok(result);
		}

		[HttpGet("get-my-groups")]
		public async Task<ActionResult<List<GroupDto>>> GetMyGroups()
		{
			return Ok(await _service.GetMyGroupsAsync(GetUserId()));
		}

		[HttpGet("get-group-details/{id}")]
		public async Task<ActionResult<GroupDetailsDto>> GetDetails(int id)
		{
			var details = await _service.GetGroupDetailsAsync(id, GetUserId());

			if (details == null)
			{
				return NotFound();
			}

			return Ok(details);
		}

		[HttpDelete("leave-group/{id}")]
		public async Task<IActionResult> Leave(int id)
		{
			await _service.LeaveGroupAsync(id, GetUserId());
			return Ok(new { message = "You left the group." });
		}
	}
}
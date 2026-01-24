using ShoppingList.API.DTOs.Logic.Group;

namespace ShoppingList.API.Services.Interfaces
{
	public interface IGroupService
	{
		public Task<GroupDto> CreateGroupAsync(CreateGroupDto dto, int userId);

		public Task<GroupDto> JoinGroupAsync(JoinGroupDto dto, int userId);

		public Task<List<GroupDto>> GetMyGroupsAsync(int userId);

		public Task<GroupDetailsDto?> GetGroupDetailsAsync(int groupId, int userId);

		public Task LeaveGroupAsync(int groupId, int userId);
	}
}
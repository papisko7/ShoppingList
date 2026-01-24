using Microsoft.EntityFrameworkCore;
using ShoppingList.API.DTOs.Logic.Group;
using ShoppingList.API.DTOs.Logic.List;
using ShoppingList.API.Services.Interfaces;
using ShoppingList.Data.Database;
using ShoppingList.Data.Entities.Logic;

namespace ShoppingList.API.Services.Logic
{
	public class GroupService : IGroupService
	{
		private readonly ShoppingListDbContext _context;

		public GroupService(ShoppingListDbContext context)
		{
			_context = context;
		}

		public async Task<GroupDto> CreateGroupAsync(CreateGroupDto dto, int userId)
		{
			string joinCode = await GenerateUniqueJoinCode();

			var newGroup = new GroupEntity
			{
				Name = dto.Name,
				JoinCode = joinCode,
				CreatedByUserId = userId,
				CreatedAt = DateTime.UtcNow
			};

			_context.Groups.Add(newGroup);
			await _context.SaveChangesAsync();

			var member = new GroupMemberEntity
			{
				GroupId = newGroup.Id,
				UserId = userId,
				JoinedAt = DateTime.UtcNow
			};

			_context.GroupMembers.Add(member);
			await _context.SaveChangesAsync();

			return new GroupDto
			{
				Id = newGroup.Id,
				Name = newGroup.Name,
				JoinCode = newGroup.JoinCode,
				MemberCount = 1,
				CreatedAt = newGroup.CreatedAt
			};
		}

		public async Task<GroupDto> JoinGroupAsync(JoinGroupDto dto, int userId)
		{
			var group = await _context.Groups.FirstOrDefaultAsync(g => g.JoinCode == dto.JoinCode);

			if (group == null)
			{
				throw new KeyNotFoundException("Invalid join code. Group not found.");
			}

			bool alreadyMember = await _context.GroupMembers.AnyAsync(m => m.GroupId == group.Id && m.UserId == userId);

			if (alreadyMember)
			{
				throw new InvalidOperationException("You are already a member of this group.");
			}

			var newMember = new GroupMemberEntity
			{
				GroupId = group.Id,
				UserId = userId
			};

			_context.GroupMembers.Add(newMember);
			await _context.SaveChangesAsync();

			return new GroupDto
			{
				Id = group.Id,
				Name = group.Name,
				JoinCode = group.JoinCode,
				MemberCount = await _context.GroupMembers.CountAsync(m => m.GroupId == group.Id),
				CreatedAt = group.CreatedAt
			};
		}

		public async Task<List<GroupDto>> GetMyGroupsAsync(int userId)
		{
			return await _context.GroupMembers
				.Where(m => m.UserId == userId)
				.Include(m => m.Group)
				.Select(m => new GroupDto
				{
					Id = m.Group!.Id,
					Name = m.Group.Name,
					JoinCode = m.Group.JoinCode,
					CreatedAt = m.Group.CreatedAt,
					MemberCount = m.Group.Members.Count()
				})
				.ToListAsync();
		}

		public async Task<GroupDetailsDto?> GetGroupDetailsAsync(int groupId, int userId)
		{
			var isMember = await _context.GroupMembers.AnyAsync(m => m.GroupId == groupId && m.UserId == userId);

			if (!isMember)
			{
				throw new UnauthorizedAccessException("You are not a member of this group.");
			}

			var group = await _context.Groups
				.Include(g => g.Members).ThenInclude(m => m.User)
				.Include(g => g.ShoppingLists)
				.FirstOrDefaultAsync(g => g.Id == groupId);

			if (group == null)
			{
				throw new KeyNotFoundException("Group not found.");
			}

			return new GroupDetailsDto
			{
				Id = group.Id,
				Name = group.Name,
				JoinCode = group.JoinCode,
				Members = group.Members.Select(m => m.User?.Username ?? "Unknown").ToList(),
				Lists = group.ShoppingLists.Select(l => new ShoppingListDto
				{
					Id = l.Id,
					Name = l.Name,
					CreatedAt = l.CreatedAt
				}).ToList()
			};
		}

		public async Task LeaveGroupAsync(int groupId, int userId)
		{
			var member = await _context.GroupMembers
				.FirstOrDefaultAsync(m => m.GroupId == groupId && m.UserId == userId);

			if (member == null)
			{
				throw new KeyNotFoundException("You are not in this group.");
			}

			_context.GroupMembers.Remove(member);
			await _context.SaveChangesAsync();
		}

		private async Task<string> GenerateUniqueJoinCode()
		{
			const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
			var random = new Random();
			string code;
			bool exists;

			do
			{
				code = new string(Enumerable.Repeat(chars, 5)
					.Select(s => s[random.Next(s.Length)]).ToArray());
				exists = await _context.Groups.AnyAsync(g => g.JoinCode == code);
			} while (exists);

			return code;
		}
	}
}
using Microsoft.AspNetCore.SignalR;

namespace ShoppingList.API.Hubs
{
	public class ShoppingHub : Hub
	{
		public async Task JoinGroup(string groupId)
		{
			await Groups.AddToGroupAsync(Context.ConnectionId, groupId);
		}

		public async Task LeaveGroup(string groupId)
		{
			await Groups.RemoveFromGroupAsync(Context.ConnectionId, groupId);
		}
	}
}
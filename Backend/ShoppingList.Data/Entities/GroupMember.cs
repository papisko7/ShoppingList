namespace ShoppingList.Data.Entities
{
	public class GroupMember
	{
		public int Id { get; set; }

		public int GroupId { get; set; }

		public int UserId { get; set; }

		public DateTime JoinedAt { get; set; }

		// relations are yet to be implemented
	}
}
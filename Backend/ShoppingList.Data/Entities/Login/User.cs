namespace ShoppingList.Data.Entities.Login
{
	public class User
	{
		public int Id { get; set; }

		public required string Username { get; set; }

		public required string PasswordHash { get; set; }

		public DateTime CreatedAt { get; set; }

		public ICollection<GroupMember> GroupMembers { get; set; }

		public ICollection<Token> Tokens { get; set; } = new List<Token>();
	}
}
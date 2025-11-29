namespace ShoppingList.Data.Entities.Login
{
	public class User
	{
		public int ID { get; set; }

		public string Username { get; set; }

		public string PasswordHash { get; set; }

		public DateTime CreatedAt { get; set; }

		public ICollection<GroupMember> GroupMembers { get; set; }

		public ICollection<Token> Tokens { get; set; } = new List<Token>();
	}
}
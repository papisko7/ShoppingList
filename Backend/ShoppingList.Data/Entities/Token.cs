namespace ShoppingList.Data.Entities
{
	public class Token
	{
		public int ID { get; set; }

		public int UserID { get; set; }

		public string RefreshToken { get; set; }

		public DateTime ExpiresAt { get; set; }

		public DateTime CreatedAt { get; set; }

		public User User { get; set; } = null!;
	}
}
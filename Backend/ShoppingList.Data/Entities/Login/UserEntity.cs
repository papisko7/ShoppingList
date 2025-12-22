namespace ShoppingList.Data.Entities.Login
{
	public class UserEntity
	{
		public int Id { get; set; }

		public required string Username { get; set; }

		public required string PasswordHash { get; set; }

		public DateTime CreatedAt { get; set; }

		public ICollection<TokenEntity> Tokens { get; set; } = new List<TokenEntity>();
	}
}
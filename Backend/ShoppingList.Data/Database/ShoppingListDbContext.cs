using Microsoft.EntityFrameworkCore;
using ShoppingList.Data.Entities.Login;

namespace ShoppingList.Data.Database
{
	public class ShoppingListDbContext : DbContext
	{
		public ShoppingListDbContext(DbContextOptions<ShoppingListDbContext> options) : base(options) { }

		public DbSet<User> Users { get; set; }

		public DbSet<Token> Tokens { get; set; }
	}
}
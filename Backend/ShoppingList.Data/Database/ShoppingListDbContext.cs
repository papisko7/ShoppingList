using Microsoft.EntityFrameworkCore;
using ShoppingList.Data.Entities.Login;

namespace ShoppingList.Data.Database
{
	public class ShoppingListDbContext : DbContext
	{
		public ShoppingListDbContext(DbContextOptions<ShoppingListDbContext> options) : base(options) { }

		public DbSet<UserEntity> Users { get; set; }

		public DbSet<TokenEntity> Tokens { get; set; }
	}
}
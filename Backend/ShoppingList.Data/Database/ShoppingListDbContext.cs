using Microsoft.EntityFrameworkCore;
using ShoppingList.Data.Entities.Logic;
using ShoppingList.Data.Entities.Login;

namespace ShoppingList.Data.Database
{
	public class ShoppingListDbContext : DbContext
	{
		public ShoppingListDbContext(DbContextOptions<ShoppingListDbContext> options) : base(options) { }

		public DbSet<UserEntity> Users { get; set; }

		public DbSet<TokenEntity> Tokens { get; set; }

		public DbSet<ProductCategoryEntity> ProductCategories { get; set; }

		public DbSet<ProductEntity> Products { get; set; }

		public DbSet<ShoppingListEntity> ShoppingLists { get; set; }

		public DbSet<ShoppingListItemEntity> ShoppingListItems { get; set; }

		protected override void OnModelCreating(ModelBuilder modelBuilder)
		{
			modelBuilder.Entity<ProductCategoryEntity>()
				.HasIndex(c => c.Name)
				.IsUnique();

			modelBuilder.Entity<ProductEntity>()
				.HasIndex(p => p.Name)
				.IsUnique();
		}
	}
}
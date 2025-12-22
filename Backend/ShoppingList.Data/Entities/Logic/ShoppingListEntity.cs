using ShoppingList.Data.Entities.Login; // For User class
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ShoppingList.Data.Entities.Logic
{
	public class ShoppingListEntity
	{
		public int Id { get; set; }

		[Required]
		public required string Name { get; set; }

		public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

		public int UserId { get; set; }

		[ForeignKey("UserId")]
		public UserEntity? User { get; set; }

		public ICollection<ShoppingListItemEntity> Items { get; set; } = new List<ShoppingListItemEntity>();
	}
}
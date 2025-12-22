using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ShoppingList.Data.Entities.Logic
{
	public class ShoppingListItemEntity
	{
		public int Id { get; set; }

		public int ShoppingListId { get; set; }
		[ForeignKey("ShoppingListId")]
		public ShoppingListEntity? ShoppingList { get; set; }

		public int ProductId { get; set; }
		[ForeignKey("ProductId")]
		public ProductEntity? Product { get; set; }

		[Required]
		public string Quantity { get; set; } = "1"; // String allows "2kg", "5 pcs"

		public bool IsBought { get; set; } = false; // Checkbox status
	}
}
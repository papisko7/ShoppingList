using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ShoppingList.Data.Entities.Logic
{
	public class ProductEntity
	{
		public int Id { get; set; }

		[Required]
		public required string Name { get; set; }

		public int CategoryId { get; set; }

		[ForeignKey("CategoryId")]
		public ProductCategoryEntity? Category { get; set; }
	}
}
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ShoppingList.Data.Entities.Logic
{
	public class ProductEntity
	{
		public int Id { get; set; }

		[Required]
		[StringLength(100, MinimumLength = 1, ErrorMessage = "Attribute name {Name} has to have a length of 1 to 100.")]
		public required string Name { get; set; }

		public int CategoryId { get; set; }

		[ForeignKey("CategoryId")]
		public ProductCategoryEntity? Category { get; set; }
	}
}
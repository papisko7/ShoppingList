using System.ComponentModel.DataAnnotations;

namespace ShoppingList.Data.Entities.Logic
{
	public class ProductCategoryEntity
	{
		public int Id { get; set; }

		[Required]
		[StringLength(100, MinimumLength = 1, ErrorMessage = "Attribute name {Name} has to have a length of 1 to 100.")]
		public required string Name { get; set; }

		public virtual ICollection<ProductEntity> Products { get; set; } = new List<ProductEntity>();
	}
}
using System.ComponentModel.DataAnnotations;

namespace ShoppingList.Data.Entities.Logic
{
	public class ProductCategoryEntity
	{
		public int Id { get; set; }

		[Required]
		public required string Name { get; set; }
	}
}
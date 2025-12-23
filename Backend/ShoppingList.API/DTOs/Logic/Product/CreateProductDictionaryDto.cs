using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs.Logic.Product
{
	public class CreateProductDictionaryDto
	{
		[Required]
		[StringLength(100, MinimumLength = 1)]
		public string Name { get; set; } = string.Empty;

		public int CategoryId { get; set; }
	}
}
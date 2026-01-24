using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs.Logic.Item
{
	public class UpdateListItemDto
	{
		[Required]
		[StringLength(50, ErrorMessage = "Quantity includes unit and should be concise.")]
		public string Quantity { get; set; } = "1";
	}
}
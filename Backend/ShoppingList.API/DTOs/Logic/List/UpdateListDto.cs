using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs.Logic.List
{
	public class UpdateListDto
	{
		[Required]
		[StringLength(100, MinimumLength = 1)]
		public string Name { get; set; } = string.Empty;
	}
}
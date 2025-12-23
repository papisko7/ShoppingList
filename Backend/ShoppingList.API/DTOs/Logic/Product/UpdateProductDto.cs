using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs.Logic.Product
{
    public class UpdateProductDto
    {
        [Required]
        [StringLength(100, MinimumLength = 1, ErrorMessage = "Attribute name {ProductName} has to have a length of 1 to 100.")]
        public required string Name { get; set; } = string.Empty;

		public int CategoryId { get; set; }
	}
}
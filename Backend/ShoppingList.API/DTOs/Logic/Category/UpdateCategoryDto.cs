using System.ComponentModel.DataAnnotations;

namespace ShoppingList.API.DTOs.Logic.Category
{
    public class UpdateCategoryDto
    {
        [Required]
        [StringLength(100, MinimumLength = 1, ErrorMessage = "Attribute name {Name} has to have a length of 1 to 100.")]
        public string Name { get; set; } = string.Empty;
	}
}
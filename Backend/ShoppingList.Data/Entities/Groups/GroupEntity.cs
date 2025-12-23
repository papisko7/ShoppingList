using System.ComponentModel.DataAnnotations;

namespace ShoppingList.Data.Entities.Logic
{
	public class GroupEntity
	{
		public int Id { get; set; }

		[Required]
		[MaxLength(100)]
		public string Name { get; set; } = string.Empty;

		[Required]
		[MaxLength(10)]
		public string JoinCode { get; set; } = string.Empty;

		public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

		public int CreatedByUserId { get; set; }

		public virtual ICollection<GroupMemberEntity> Members { get; set; } = new List<GroupMemberEntity>();

		public virtual ICollection<ShoppingListEntity> ShoppingLists { get; set; } = new List<ShoppingListEntity>();
	}
}
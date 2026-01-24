using ShoppingList.Data.Entities.Login;
using System.ComponentModel.DataAnnotations.Schema;

namespace ShoppingList.Data.Entities.Logic
{
	public class GroupMemberEntity
	{
		public int Id { get; set; }

		public int GroupId { get; set; }

		[ForeignKey("GroupId")]
		public virtual GroupEntity? Group { get; set; }

		public int UserId { get; set; }

		[ForeignKey("UserId")]
		public virtual UserEntity? User { get; set; }

		public DateTime JoinedAt { get; set; } = DateTime.UtcNow;
	}
}
namespace ShoppingList.API.DTOs.Logic.Group
{
	public class GroupDto
	{
		public int Id { get; set; }

		public string Name { get; set; } = string.Empty;

		public string JoinCode { get; set; } = string.Empty;

		public int MemberCount { get; set; }

		public DateTime CreatedAt { get; set; }
	}
}
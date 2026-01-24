using ShoppingList.Data.Entities.Login;

namespace ShoppingList.API.Services
{
	public interface ITokenService
	{
		public string CreateAccessToken(UserEntity user);

		public string GenerateRefreshToken();
	}
}
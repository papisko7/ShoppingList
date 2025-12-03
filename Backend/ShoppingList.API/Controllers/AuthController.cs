using Microsoft.AspNetCore.Mvc;
using ShoppingList.Data.Database;

namespace ShoppingList.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly ShoppingListDbContext _context;

        public AuthController(ShoppingListDbContext context)
        {
            _context = context;
        }

        [HttpPost("test-connection")]
        public IActionResult TestConnection()
        {
            bool canConnect = _context.Database.CanConnect();

            if (canConnect)
            {
                return Ok("✅ SUCCESS: Connected to the Database!");
            }
            return BadRequest("❌ FAILURE: Could not connect.");
        }
    }
}
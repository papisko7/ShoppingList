using System.Net;
using System.Text.Json;

namespace ShoppingList.API.Middleware
{
	public class ExceptionMiddleware
	{
		private readonly RequestDelegate _next;
		private readonly ILogger<ExceptionMiddleware> _logger;

		public ExceptionMiddleware(RequestDelegate next, ILogger<ExceptionMiddleware> logger, IHostEnvironment env)
		{
			_next = next;
			_logger = logger;
		}

		public async Task InvokeAsync(HttpContext context)
		{
			try
			{
				await _next(context);
			}
			catch (Exception ex)
			{
				_logger.LogError(ex, ex.Message);
				await HandleExceptionAsync(context, ex);
			}
		}

		private static Task HandleExceptionAsync(HttpContext context, Exception exception)
		{
			context.Response.ContentType = "application/json";

			var statusCode = (int)HttpStatusCode.InternalServerError;
			var message = "Internal Server Error";

			switch (exception)
			{
				case ArgumentException:
					statusCode = (int)HttpStatusCode.BadRequest;
					message = exception.Message;
					break;

				case InvalidOperationException:
				case ApplicationException:
					statusCode = (int)HttpStatusCode.BadRequest;
					message = exception.Message;
					break;

				case KeyNotFoundException:
					statusCode = (int)HttpStatusCode.NotFound;
					message = exception.Message;
					break;

				case Microsoft.EntityFrameworkCore.DbUpdateException:
					statusCode = (int)HttpStatusCode.Conflict;
					message = "Data conflict or duplicate entry.";
					break;
			}

			context.Response.StatusCode = statusCode;

			var result = JsonSerializer.Serialize(new { error = message });
			return context.Response.WriteAsync(result);
		}
	}
}
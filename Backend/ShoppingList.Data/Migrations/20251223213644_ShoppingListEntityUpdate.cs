using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ShoppingList.Data.Migrations
{
    /// <inheritdoc />
    public partial class ShoppingListEntityUpdate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ShoppingLists_Groups_GroupEntityId",
                table: "ShoppingLists");

            migrationBuilder.RenameColumn(
                name: "GroupEntityId",
                table: "ShoppingLists",
                newName: "GroupId");

            migrationBuilder.RenameIndex(
                name: "IX_ShoppingLists_GroupEntityId",
                table: "ShoppingLists",
                newName: "IX_ShoppingLists_GroupId");

            migrationBuilder.AddForeignKey(
                name: "FK_ShoppingLists_Groups_GroupId",
                table: "ShoppingLists",
                column: "GroupId",
                principalTable: "Groups",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ShoppingLists_Groups_GroupId",
                table: "ShoppingLists");

            migrationBuilder.RenameColumn(
                name: "GroupId",
                table: "ShoppingLists",
                newName: "GroupEntityId");

            migrationBuilder.RenameIndex(
                name: "IX_ShoppingLists_GroupId",
                table: "ShoppingLists",
                newName: "IX_ShoppingLists_GroupEntityId");

            migrationBuilder.AddForeignKey(
                name: "FK_ShoppingLists_Groups_GroupEntityId",
                table: "ShoppingLists",
                column: "GroupEntityId",
                principalTable: "Groups",
                principalColumn: "Id");
        }
    }
}

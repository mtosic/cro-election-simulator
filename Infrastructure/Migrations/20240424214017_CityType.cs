using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class CityType : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "TotalVotes",
                table: "CandidateVote",
                newName: "Total");

            migrationBuilder.AddColumn<string>(
                name: "Type",
                table: "Cities",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Type",
                table: "Cities");

            migrationBuilder.RenameColumn(
                name: "Total",
                table: "CandidateVote",
                newName: "TotalVotes");
        }
    }
}

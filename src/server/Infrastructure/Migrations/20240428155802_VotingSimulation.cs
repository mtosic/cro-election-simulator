using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class VotingSimulation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "VotingSimulations",
                columns: table => new
                {
                    SimulationId = table.Column<int>(type: "int", nullable: false),
                    SimulationName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ConstituencyNumber = table.Column<int>(type: "int", nullable: false),          
                    ConstituencyName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ConstituencyDescription = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PartyName = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Votes = table.Column<int>(type: "int", nullable: false),
                    TotalVotes = table.Column<int>(type: "int", nullable: false),
                    VotesPercentage = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_VotingSimulations", x => new { x.SimulationId, x.ConstituencyNumber, x.PartyName });
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "VotingSimulations");
        }
    }
}

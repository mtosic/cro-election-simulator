using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class ConstituencySimulation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ConstituencySimulations",
                columns: table => new
                {
                    SimulationId = table.Column<int>(type: "int", nullable: false),
                    SimulationName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ConstituencyNumber = table.Column<int>(type: "int", nullable: false),                    
                    ConstituencyName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ConstituencyDescription = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    VotingPopulation = table.Column<int>(type: "int", nullable: false),
                    TotalVotes = table.Column<int>(type: "int", nullable: false),
                    TotalVotesByBallot = table.Column<int>(type: "int", nullable: false),
                    ValidVotes = table.Column<int>(type: "int", nullable: false),
                    InvalidVotes = table.Column<int>(type: "int", nullable: false),
                    NumberOfMandates = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ConstituencySimulations", x => new { x.SimulationId, x.ConstituencyNumber });
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ConstituencySimulations");
        }
    }
}

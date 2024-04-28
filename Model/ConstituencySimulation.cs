namespace Model;

public class ConstituencySimulation
{
    public int SimulationId { get; set; }
    public required string SimulationName { get; set; }
    public int ConstituencyNumber { get; set; }
    public required string ConstituencyName { get; set; }
    public required string ConstituencyDescription { get; set; }
    public int VotingPopulation { get; set; }
    public int TotalVotes { get; set; }
    public int TotalVotesByBallot { get; set; }
    public int ValidVotes { get; set; }
    public int InvalidVotes { get; set; }
    public int NumberOfMandates { get; set; }


}

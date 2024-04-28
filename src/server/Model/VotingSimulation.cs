namespace Model;

public class VotingSimulation
{
    public int SimulationId { get; set; }
    public required string SimulationName { get; set; }
    public int ConstituencyNumber { get; set; }
    public required string ConstituencyName { get; set; }
    public required string ConstituencyDescription { get; set; }
    public required string PartyName { get; set; }
    public int Votes { get; set; }
    public int TotalVotes { get; set; }
    public decimal VotesPercentage { get; set; }
}

namespace Model;

public class PollingStation
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public required string Code { get; set; }
    public required string Location { get; set; }
    public required string Address { get; set; }
    public int VotingPopulation { get; set; }
    public int TotalVotes { get; set; }
    public int TotalVotesByBallot { get; set; }
    public int ValidVotes { get; set; }
    public int InvalidVotes { get; set; }
    public int CityId { get; set; }
    public required City City { get; set; }
}

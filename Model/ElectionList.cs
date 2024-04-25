namespace Model;

public class ElectionList
{
    public int Id { get; set; }
    public int PartyId { get; set; }
    public required Party Party { get; set; }
    public int PollingStationId { get; set; }
    public required PollingStation PollingStation { get; set; }
    public int TotalVotes { get; set; }
    public List<CandidateVote> CandidateVotes { get; set; } = null!;
}

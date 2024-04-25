namespace Model;

public class CandidateVote
{
    public int Id { get; set; }
    public int CandidateId { get; set; }
    public required Candidate Candidate { get; set; }
    public int ElectionListId { get; set; }
    public required ElectionList ElectionList { get; set; }
    public int Total { get; set; }
}

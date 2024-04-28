namespace Model;

public class Candidate
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public int PartyId { get; set; }
    public required Party Party { get; set; }

}

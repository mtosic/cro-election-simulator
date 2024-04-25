namespace Model;

public class County
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public required string Code { get; set; }
    public int ConstituencyId { get; set; }
    public required Constituency Constituency { get; set; }
}

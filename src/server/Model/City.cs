namespace Model;

public class City
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public required string Type { get; set; }
    public int CountyId { get; set; }
    public required County County { get; set; }
}

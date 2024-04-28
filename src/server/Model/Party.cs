namespace Model;

public class Party
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public string ShortName { get; set; } = String.Empty;
}

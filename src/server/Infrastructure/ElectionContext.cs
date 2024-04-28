using Microsoft.EntityFrameworkCore;
using Model;

namespace Infrastructure;

public class ElectionContext: DbContext
{
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer(@"Server=.;Database=Izbori2024;Trusted_Connection=True;MultipleActiveResultSets=True;Encrypt=False;");
    }

    public DbSet<Constituency> Constituencies { get; set; }
    public DbSet<County> Counties { get; set; }
    public DbSet<City> Cities { get; set; }
    public DbSet<Party> Parties { get; set; }
    public DbSet<Candidate> Candidates { get; set; }
    public DbSet<ElectionList> ElectionLists { get; set; }
    public DbSet<PollingStation> PollingStations { get; set; }
    public DbSet<ConstituencySimulation> ConstituencySimulations { get; set; }
    public DbSet<VotingSimulation> VotingSimulations { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<CandidateVote>()
            .HasOne(p => p.ElectionList)
            .WithMany(b => b.CandidateVotes)
            .HasForeignKey(p => p.ElectionListId)
            .OnDelete(DeleteBehavior.NoAction);

        modelBuilder.Entity<ConstituencySimulation>()
            .HasKey(cs => new { cs.SimulationId, cs.ConstituencyNumber });

        modelBuilder.Entity<VotingSimulation>()
            .HasKey(vs => new { vs.SimulationId, vs.ConstituencyNumber, vs.PartyName });

    }

}

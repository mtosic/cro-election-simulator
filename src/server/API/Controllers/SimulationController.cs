using Infrastructure;
using Microsoft.AspNetCore.Mvc;
using Model;

namespace API.Controllers;

[ApiController]
[Route("[controller]")]
public class SimulationController : ControllerBase
{
    private readonly ILogger<SimulationController> _logger;
    private readonly ElectionContext db;

    public SimulationController(ILogger<SimulationController> logger, ElectionContext context)
    {
        _logger = logger;
        db = context;
    }

    [HttpGet("Constituencies")]
    public IEnumerable<ConstituencySimulation> GetConstituencies()
    {
        return db.ConstituencySimulations.ToList();
    }

    [HttpGet("Votes")]
    public IEnumerable<VotingSimulation> GetVotes()
    {
        return db.VotingSimulations.ToList();
    }
}

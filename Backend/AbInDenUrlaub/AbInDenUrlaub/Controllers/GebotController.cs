using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Data.Entity.Core.EntityClient;

namespace AbInDenUrlaub.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GebotController : ControllerBase
    {

        private readonly Projekt1Context context;

        public GebotController(Projekt1Context context)
        {
            this.context = context;
        }

        [HttpGet]
        public async Task<ActionResult<List<Gebot>>> Get()
        {
            return Ok(await context.Gebots.ToListAsync());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<List<Gebot>>> GetGeboteForUser(int id)
        {
            List<Gebot> gebotes = await context.Gebots.ToListAsync();

            List<Gebot> list = new();

            foreach (Gebot gebot in gebotes)
            {
                if(gebot.UserId == id)
                {
                    list.Add(gebot);
                }
            }

            return Ok(list);
        }

        [HttpGet("{UserID}/{AngID}")]
        public async Task<ActionResult<List<Gebot>>> GetGebote(int UserID, int AngID)
        {
            List<Gebot> gebotes = await context.Gebots.ToListAsync();

            List<Gebot> list = new();

            foreach (Gebot gebot in gebotes)
            {
                if (gebot.UserId == UserID && gebot.AngebotId == AngID)
                {
                    list.Add(gebot);
                }
            }

            return Ok(list);
        }

        [HttpPost]
        public async Task<ActionResult<List<Gebot>>> AddGebot (Gebot newGebot)
        {
            context.Gebots.Add(newGebot);
            await context.SaveChangesAsync();

            return Ok(await context.Gebots.ToListAsync());
        }

    }
}

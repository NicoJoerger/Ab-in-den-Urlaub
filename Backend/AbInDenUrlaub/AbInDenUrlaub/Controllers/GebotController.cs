using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

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
                if (gebot.UserId == id)
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
        public async Task<ActionResult<List<Gebot>>> AddGebot(Gebot newGebot)
        {
            var dbAngebot = await context.Angebotes.FindAsync(newGebot.AngebotId);
            if (dbAngebot == null)
            {
                return BadRequest("Angebot not found");
            }
            if (newGebot.Preis > dbAngebot.AktuellerTokenpreis)
            {
                context.Gebots.Add(newGebot);
            }
            await context.SaveChangesAsync();

            return Ok(newGebot);
        }

        [HttpPut]
        public async Task<ActionResult<List<Gebot>>> UpdateGebot(Gebot updatedGebot)
        {
            var dbGebot = await context.Gebots.FindAsync(updatedGebot.GebotId);
            if (dbGebot == null)
            {
                return BadRequest("Gebot not found");
            }

            if (updatedGebot.Preis > dbGebot.Preis)
            {
                dbGebot.Angebot = updatedGebot.Angebot;
                dbGebot.User = updatedGebot.User;
                dbGebot.Preis = updatedGebot.Preis;

                var dbAngebot = await context.Angebotes.FindAsync(updatedGebot.AngebotId);
                if (dbAngebot == null)
                {
                    return BadRequest("Angebot not found");
                }
                dbAngebot.AktuellerTokenpreis = dbGebot.Preis;
            }
            else
            {
                return BadRequest("Preis muss größer sein als der alte");
            }

            await context.SaveChangesAsync();

            return Ok(dbGebot);
        }

    }
}

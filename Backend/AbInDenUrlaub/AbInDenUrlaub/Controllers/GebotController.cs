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
            List<Gebot> gebote = await context.Gebots.ToListAsync();
            Gebot emptyGebot = new Gebot();
            Gebot dbGebot = emptyGebot;

            foreach (Gebot item in gebote)
            {
                if (item.AngebotId == updatedGebot.AngebotId)
                {
                    dbGebot = item;
                }
            }

            Nutzer user = await context.Nutzers.FindAsync(updatedGebot.UserId);
            if (user == null)
            {
                return BadRequest("User not found");
            }
            if (user.Tokenstand < updatedGebot.Preis)
            {
                return BadRequest("User hat nicht genug Token");
            }


            if (dbGebot.Equals(emptyGebot))
            {
                var dbAngebot = await context.Angebotes.FindAsync(updatedGebot.AngebotId);
                if (dbAngebot == null)
                {
                    return BadRequest("Angebot not found");
                }
                if (updatedGebot.Preis > dbAngebot.AktuellerTokenpreis)
                {

                    context.Gebots.Add(updatedGebot);
                    await context.SaveChangesAsync();
                    return Ok(updatedGebot);
                }
            }

            if (updatedGebot.Preis > dbGebot.Preis)
            {
                //dbGebot.Angebot = updatedGebot.Angebot;
                //dbGebot.User = updatedGebot.User;
                dbGebot.Preis = updatedGebot.Preis;
                //dbGebot.AngebotId = updatedGebot.AngebotId;
                dbGebot.UserId = updatedGebot.UserId;

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

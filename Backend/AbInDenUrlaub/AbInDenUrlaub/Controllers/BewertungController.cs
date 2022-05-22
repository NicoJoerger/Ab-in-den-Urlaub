using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AbInDenUrlaub.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BewertungController : ControllerBase
    {

        private readonly Projekt1Context context;

        public BewertungController(Projekt1Context context)
        {
            this.context = context;
        }

        [HttpGet]
        public async Task<ActionResult<List<Bewertung>>> Get()
        {
            return Ok(await context.Bewertungs.ToListAsync());
        }

        [HttpGet("{UserID}/{FwID}")]
        public async Task<ActionResult<List<Bewertung>>> GetMatchingBewertung(int UserID, int FwID)
        {
            List<Bewertung> bewertungs = await context.Bewertungs.ToListAsync();

            List<Bewertung> list = new();

            foreach (var bewertung in bewertungs)
            {
                if(bewertung.UserId == UserID && bewertung.FwId == FwID)
                {
                    list.Add(bewertung);
                }
            }

            return Ok(list);
        }

        [HttpGet("{UserID}/user")]
        public async Task<ActionResult<List<Bewertung>>> GetuserBewertung(int UserID)
        {
            List<Bewertung> bewertungs = await context.Bewertungs.ToListAsync();

            List<Bewertung> list = new();

            foreach (var bewertung in bewertungs)
            {
                if (bewertung.UserId == UserID)
                {
                    list.Add(bewertung);
                }
            }

            return Ok(list);
        }

        [HttpGet("{FwID}/fw")]
        public async Task<ActionResult<List<Bewertung>>> GetWohnungBewertung(int FwID)
        {
            List<Bewertung> bewertungs = await context.Bewertungs.ToListAsync();

            List<Bewertung> list = new();

            foreach (var bewertung in bewertungs)
            {
                if (bewertung.FwId == FwID)
                {
                    list.Add(bewertung);
                }
            }

            return Ok(list);
        }

        [HttpPost]
        public async Task<ActionResult<List<Bewertung>>> AddBewertung(Bewertung newBewertung)
        {
            context.Bewertungs.Add(newBewertung);
            await context.SaveChangesAsync();

            return Ok(await context.Bewertungs.ToListAsync());
        }

        [HttpPut]
        public async Task<ActionResult<List<Bewertung>>> UpdateBewertung(Bewertung updatedBewertung)
        {
            var dbBewertung = await context.Bewertungs.FindAsync(updatedBewertung.BewertungId);
            if(dbBewertung == null)
            {
                return BadRequest("Bewertung not found");
            }

            dbBewertung.Anzsterne = updatedBewertung.Anzsterne;
            dbBewertung.Kommentar = updatedBewertung.Kommentar;

            await context.SaveChangesAsync();

            return Ok(await context.Bewertungs.ToListAsync());
        }

        [HttpDelete]
        public async Task<ActionResult<List<Bewertung>>> DeleteBewertung(int id)
        {
            var toDelete = await context.Bewertungs.FindAsync(id);
            if(toDelete == null)
            {
                return BadRequest("Bewertung not found");
            }

            context.Remove(toDelete);

            await context.SaveChangesAsync();

            return Ok(toDelete);

        }
    }
}

using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AbInDenUrlaub.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AngeboteController : ControllerBase
    {
        private readonly Projekt1Context context;

        public AngeboteController(Projekt1Context context)
        {
            this.context = context;
        }

        [HttpGet]
        public async Task<ActionResult<List<Angebote>>> Get()
        {
            return Ok(await context.Angebotes.ToListAsync());
        }

        [HttpGet("/filtered")]
        public async Task<ActionResult<List<Angebote>>> GetFiltered(DateTime MietzeitraumStart, DateTime MietzeitraumEnde, int Mietpreis, int Tokenpreis, String Land)
        {
            List<Angebote> list = await context.Angebotes.ToListAsync();

            List<Angebote> retList = new();

            foreach (Angebote angebote in list)
            {
                var temp = await context.Ferienwohnungs.FindAsync(angebote.FwId);
                if (Land.Equals("Ohne"))
                {
                    if (angebote.MietzeitraumStart >= MietzeitraumStart && angebote.MietzeitraumEnde <= MietzeitraumEnde && angebote.Mietpreis <= Mietpreis && angebote.AktuellerTokenpreis <= Tokenpreis)
                    {
                        retList.Add(angebote);
                        context.Entry(angebote).Reference(s => s.Fw).Load();
                    }
                }
                else
                {
                    if (angebote.MietzeitraumStart >= MietzeitraumStart && angebote.MietzeitraumEnde <= MietzeitraumEnde && angebote.Mietpreis <= Mietpreis && angebote.AktuellerTokenpreis <= Tokenpreis && temp.land.Equals(Land))
                    {
                        retList.Add(angebote);
                        context.Entry(angebote).Reference(s => s.Fw).Load();
                    }
                }
            }


            return Ok(retList);
        }


        [HttpGet("{id}/a")]
        public async Task<ActionResult<List<Angebote>>> GetByAngID(int id)
        {
            List<Angebote> angebotes = await context.Angebotes.ToListAsync();

            List<Angebote> list = new();

            foreach (Angebote angebot in angebotes)
            {
                if (angebot.AngebotId == id)
                {
                    list.Add(angebot);
                }
            }

            return Ok(list);
        }


        [HttpGet("{id}/fw")]
        public async Task<ActionResult<List<Angebote>>> GetByAngFW(int id)
        {
            List<Angebote> angebotes = await context.Angebotes.ToListAsync();

            List<Angebote> list = new();

            foreach (Angebote angebot in angebotes)
            {
                if (angebot.FwId == id)
                {
                    list.Add(angebot);
                }
            }

            return Ok(list);
        }

        [HttpPost]
        public async Task<ActionResult<List<Angebote>>> AddAngebot(Angebote newAngebot)
        {
            newAngebot.AktuellerTokenpreis = 100;
            context.Add(newAngebot);
            await context.SaveChangesAsync();

            return Ok(await context.Angebotes.ToListAsync());

        }

        [HttpPut]
        public async Task<ActionResult<List<Angebote>>> UpdateAngebot(Angebote updatedAngebot)
        {
            var dbAngebot = await context.Angebotes.FindAsync(updatedAngebot.FwId);
            if (dbAngebot == null)
            {
                return BadRequest("Angebot not found");
            }

            dbAngebot.MietzeitraumStart = updatedAngebot.MietzeitraumStart;
            dbAngebot.MietzeitraumEnde = updatedAngebot.MietzeitraumEnde;
            dbAngebot.AuktionEnddatum = updatedAngebot.AuktionEnddatum;
            dbAngebot.AktuellerTokenpreis = updatedAngebot.AktuellerTokenpreis;
            dbAngebot.Mietpreis = updatedAngebot.Mietpreis;
            dbAngebot.Stornierbar = updatedAngebot.Stornierbar;

            await context.SaveChangesAsync();

            return Ok(await context.Angebotes.ToListAsync());
        }

        [HttpPut("{angebotID}")]
        public async Task<ActionResult<List<Angebote>>> deactivateAngebot(int angebotID)
        {
            var ag = await context.Angebotes.FindAsync(angebotID);
            List<Gebot> gebote = await context.Gebots.ToListAsync();


            if (ag.MietzeitraumEnde > DateTime.Now)
            {
                foreach (var gebot in gebote)
                {
                    if (gebot.AngebotId == ag.AngebotId)
                    {
                        Nutzer user = await context.Nutzers.FindAsync(gebot.UserId);
                        if (user != null)
                        {
                            user.Tokenstand = gebot.Preis + user.Tokenstand;
                        }
                        context.Gebots.Remove(gebot);
                    }

                }
                context.Angebotes.Remove(ag);
            }

            return Ok(ag);
        }

        [HttpGet("aktuell")]
        public async Task<ActionResult<List<Angebote>>> GetAktuelle()
        {
            List<Angebote> angebote = await context.Angebotes.ToListAsync();

            foreach (var angebot in angebote)
            {
                if (angebot.AuktionEnddatum < DateTime.Now)
                {
                    angebote.Remove(angebot);
                }
            }

            return Ok(angebote);
        }


    }
}

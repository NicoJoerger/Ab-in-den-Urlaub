using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AbInDenUrlaub.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FerienwohnungController : ControllerBase
    {

        private readonly Projekt1Context context;

        public FerienwohnungController(Projekt1Context context)
        {
            this.context = context;
        }

        [HttpGet]
        public async Task<ActionResult<List<Ferienwohnung>>> Get()
        {
            return Ok(await context.Ferienwohnungs.ToListAsync());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<List<Ferienwohnung>>> GetbyID(int id)
        {
            var wohnung = await context.Ferienwohnungs.FindAsync(id);
            if (wohnung == null)
            {
                return BadRequest("Apartment not found");
            }
            return Ok(wohnung);
        }

        [HttpGet("{UserID}/user")]
        public async Task<ActionResult<List<Ferienwohnung>>> GetWohnungByUser(int UserID)
        {
            List<Ferienwohnung> wohnungs = await context.Ferienwohnungs.ToListAsync();

            List<Ferienwohnung> list = new();

            foreach (var wohnung in wohnungs)
            {
                if (wohnung.UserId == UserID)
                {
                    list.Add(wohnung);
                }
            }

            return Ok(list);
        }

        [HttpPost]
        public async Task<ActionResult<List<Ferienwohnung>>> AddFerienwohnung(Ferienwohnung wohnung, IList<IFormFile> newImages)
        {
            context.Ferienwohnungs.Add(wohnung);

            foreach (var image in newImages)
            {
                Wohnungsbilder newBilder = new Wohnungsbilder();
                newBilder.FwId = wohnung.FwId;

                context.Wohnungsbilders.Add(newBilder);
                context.SaveChanges();
                await using var memStream = new MemoryStream();

                await image.CopyToAsync(memStream);
                await memStream.FlushAsync();
                Bilder newBild = new Bilder();
                newBild.Bild = memStream.ToArray();
                context.Bilders.Add(newBild);
                context.SaveChanges();

                newBilder.BildId = newBild.BildId;

            }

            await context.SaveChangesAsync();

            return Ok(await context.Ferienwohnungs.ToListAsync());
        }


        [HttpPut]
        public async Task<ActionResult<List<Ferienwohnung>>> UpdateFerienwohnung(Ferienwohnung updatedWohnung)
        {
            var dbWohnung = await context.Ferienwohnungs.FindAsync(updatedWohnung.UserId);
            if (dbWohnung == null)
            {
                return BadRequest("Apartment not found");
            }

            dbWohnung.Strasse = updatedWohnung.Strasse;
            dbWohnung.hausnummer = updatedWohnung.hausnummer;
            dbWohnung.Ort = updatedWohnung.Ort;
            dbWohnung.Plz = updatedWohnung.Plz;
            dbWohnung.Wohnflaeche = updatedWohnung.Wohnflaeche;
            dbWohnung.Anzzimmer = updatedWohnung.Anzzimmer;
            dbWohnung.Anzbetten = updatedWohnung.Anzbetten;
            dbWohnung.Anzbaeder = updatedWohnung.Anzbaeder;
            dbWohnung.Wifi = updatedWohnung.Wifi;
            dbWohnung.Garten = updatedWohnung.Garten;
            dbWohnung.Balkon = updatedWohnung.Balkon;
            dbWohnung.Beschreibung = updatedWohnung.Beschreibung;


            await context.SaveChangesAsync();

            return Ok(await context.Ferienwohnungs.ToListAsync());
        }

        [HttpPut("deactivate")]
        public async Task<ActionResult<List<Ferienwohnung>>> deactivateWohnung(int WohnungID)
        {
            var toDeactivate = await context.Ferienwohnungs.FindAsync(WohnungID);
            if (toDeactivate == null)
            {
                return BadRequest("Wohnung not found");
            }

            List<Ferienwohnung> wohnungen = await context.Ferienwohnungs.ToListAsync();
            List<Angebote> angebote = await context.Angebotes.ToListAsync();

            foreach (Ferienwohnung fw in wohnungen)
            {
                foreach (Angebote ag in angebote)
                {
                    if (ag.FwId == fw.FwId)
                    {
                        if (ag.MietzeitraumEnde > DateTime.Now)
                        {
                            return BadRequest("Wohnung hat aktive Angebote");
                        }
                    }
                }
            }


            toDeactivate.deaktiviert = true;

            await context.SaveChangesAsync();

            return Ok(toDeactivate);
        }
    }
}

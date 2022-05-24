using Microsoft.AspNetCore.Http;
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

        [HttpPost]
        public async Task<ActionResult<List<Ferienwohnung>>> AddFerienwohnung(Ferienwohnung wohnung)
        {
            context.Ferienwohnungs.Add(wohnung);
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
    }
}

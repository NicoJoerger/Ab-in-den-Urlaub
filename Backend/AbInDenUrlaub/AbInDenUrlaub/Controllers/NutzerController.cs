using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AbInDenUrlaub.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NutzerController : ControllerBase
    {
        private readonly Projekt1Context context;

        public NutzerController(Projekt1Context context)
        {
            this.context = context;
        }

        [HttpGet]
        public async Task<ActionResult<List<Nutzer>>> Get()
        {
            return Ok(await context.Nutzers.ToListAsync());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<List<Nutzer>>> GetbyID(int id)
        {
            var nutzer = await context.Nutzers.FindAsync(id);
            if(nutzer == null)
            {
                return BadRequest("User not found");
            }
            return Ok(nutzer);
        }

        [HttpPost]
        public async Task<ActionResult<List<Nutzer>>> AddNutzer(Nutzer nutzer)
        {
            context.Nutzers.Add(nutzer);
            await context.SaveChangesAsync();

            return Ok(await context.Nutzers.ToListAsync());
        }

        [HttpPut]
        public async Task<ActionResult<List<Nutzer>>> UpdateNutzer(Nutzer updatedNutzer)
        {
            var dbNutzer = await context.Nutzers.FindAsync(updatedNutzer.UserId);
            if(dbNutzer == null)
            {
                return BadRequest("User not found");
            }

            dbNutzer.Username = updatedNutzer.Username;
            dbNutzer.Vorname = updatedNutzer.Vorname;
            dbNutzer.Password = updatedNutzer.Password;
            dbNutzer.Email = updatedNutzer.Email;
            dbNutzer.Email = updatedNutzer.Email;
            dbNutzer.Tokenstand = updatedNutzer.Tokenstand;
            dbNutzer.Admin = updatedNutzer.Admin;
            dbNutzer.Vermieter = updatedNutzer.Vermieter;

            await context.SaveChangesAsync();

            return Ok(await context.Nutzers.ToListAsync());
        }

       
    }
}

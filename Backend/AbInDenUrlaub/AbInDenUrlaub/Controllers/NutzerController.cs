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

        [HttpGet("/login")]
        public async Task<ActionResult<List<Nutzer>>> Login(String email, String password)
        {
            List<Nutzer> users = await context.Nutzers.ToListAsync();
            List<Nutzer> retList = new();

            foreach (Nutzer user in users)
            {
                if (user.Email.Equals(email) && user.Password.Equals(password))
                {
                    retList.Add(user);
                    TimeSpan ts = DateTime.Now - user.lastbuy;
                    if (ts.Days > 365)
                    {
                        user.Tokenstand = user.Tokenstand + 100;
                        user.lastbuy = DateTime.UtcNow;
                    }
                    await context.SaveChangesAsync();
                    return Ok(retList);
                }
            }
            await context.SaveChangesAsync();
            return BadRequest("Invalid credentials");
        }


        [HttpGet("{id}")]
        public async Task<ActionResult<List<Nutzer>>> GetbyID(int id)
        {
            var nutzer = await context.Nutzers.FindAsync(id);
            if (nutzer == null)
            {
                return BadRequest("User not found");
            }
            return Ok(nutzer);
        }

        [HttpPost]
        public async Task<ActionResult<List<Nutzer>>> AddNutzer(Nutzer nutzer)
        {
            List<Nutzer> list = await context.Nutzers.ToListAsync();
            foreach (Nutzer n in list)
            {
                if (n.Username == nutzer.Username)
                {
                    return BadRequest("Duplicate Username");
                }

                if (n.Email == nutzer.Email)
                {
                    return BadRequest("Duplicate E-Mail");
                }
            }
            context.Nutzers.Add(nutzer);
            nutzer.lastbuy = DateTime.UtcNow;
            await context.SaveChangesAsync();

            return Ok(await context.Nutzers.ToListAsync());
        }

        [HttpPut]
        public async Task<ActionResult<List<Nutzer>>> UpdateNutzer(Nutzer updatedNutzer)
        {
            var dbNutzer = await context.Nutzers.FindAsync(updatedNutzer.UserId);
            if (dbNutzer == null)
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

        [HttpPut("/deactivate")]
        public async Task<ActionResult<List<Nutzer>>> deactivateNutzer(int UserID)
        {
            var toDeactivate = await context.Nutzers.FindAsync(UserID);
            if (toDeactivate == null)
            {
                return BadRequest("Nutzer not found");
            }

            List<Ferienwohnung> wohnungs = await context.Ferienwohnungs.ToListAsync();
            List<Angebote> angebote = await context.Angebotes.ToListAsync();


            List<Ferienwohnung> list = new();

            foreach (var wohnung in wohnungs)
            {
                if (wohnung.UserId == UserID)
                {
                    list.Add(wohnung);
                }
            }

            foreach (Ferienwohnung fw in list)
            {
                foreach (Angebote ag in angebote)
                {
                    if (ag.FwId == fw.FwId)
                    {
                        if (ag.MietzeitraumEnde > DateTime.Now)
                        {
                            return BadRequest("User hat aktive Angebote");
                        }
                    }
                }
            }

            toDeactivate.deaktiviert = true;

            await context.SaveChangesAsync();

            return Ok(toDeactivate);

        }

        [HttpPut("/deactivate/admin/{UserID}")]
        public async Task<ActionResult<List<Nutzer>>> deactivateNutzerAdmin(int UserID)
        {
            var toDeactivate = await context.Nutzers.FindAsync(UserID);
            if (toDeactivate == null)
            {
                return BadRequest("Nutzer not found");
            }

            List<Ferienwohnung> wohnungs = await context.Ferienwohnungs.ToListAsync();
            List<Angebote> angebote = await context.Angebotes.ToListAsync();
            List<Gebot> gebote = await context.Gebots.ToListAsync();


            List<Ferienwohnung> list = new();

            foreach (var wohnung in wohnungs)
            {
                if (wohnung.UserId == UserID)
                {
                    list.Add(wohnung);
                }
            }

            foreach (var gebot in gebote)
            {
                if (gebot.UserId == UserID)
                {
                    context.Gebots.Remove(gebot);
                }
            }

            foreach (Ferienwohnung fw in list)
            {
                foreach (Angebote ag in angebote)
                {
                    if (ag.FwId == fw.FwId)
                    {
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
                    }
                }
            }

            toDeactivate.deaktiviert = true;

            await context.SaveChangesAsync();

            return Ok(toDeactivate);

        }

    }
}

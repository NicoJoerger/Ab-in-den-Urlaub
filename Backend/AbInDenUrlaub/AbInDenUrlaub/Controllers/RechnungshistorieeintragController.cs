using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AbInDenUrlaub.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RechnungshistorieeintragController : ControllerBase
    {

        private readonly Projekt1Context context;

        public RechnungshistorieeintragController(Projekt1Context context)
        {
            this.context = context;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<List<Rechnungshistorieeintrag>>> GetHistorie(int id)
        {
            List<Rechnungshistorieeintrag> historie = await context.Rechnungshistorieeintrags.ToListAsync();

            List<Rechnungshistorieeintrag> list = new();

            foreach (Rechnungshistorieeintrag item in historie)
            {
                if (item.UserId == id)
                {
                    list.Add(item);
                }
            }


            return Ok(list);
        }

        [HttpGet]
        public async Task<ActionResult<List<Rechnungshistorieeintrag>>> Get()
        {
            IList<Rechnungshistorieeintrag> rechnungshistorie = await context.Rechnungshistorieeintrags.ToListAsync();

            return Ok(rechnungshistorie.ToList());
        }

        [HttpPost]
        public async Task<ActionResult<List<Rechnungshistorieeintrag>>> AddEintrag(Rechnungshistorieeintrag eintrag)
        {
            var user = await context.Nutzers.FindAsync(eintrag.UserId);
            user.lastBuy = DateTime.Now;
            context.Rechnungshistorieeintrags.Add(eintrag);
            await context.SaveChangesAsync();

            return Ok(await context.Nutzers.ToListAsync());
        }

        [HttpPut]
        public async Task<ActionResult<List<Rechnungshistorieeintrag>>> UpdateEintrag(Rechnungshistorieeintrag updatedEintrag)
        {
            var dbEintrag = await context.Rechnungshistorieeintrags.FindAsync(updatedEintrag.RhId);
            if (dbEintrag == null)
            {
                return BadRequest("Entry not found");
            }

            dbEintrag.Storniert = updatedEintrag.Storniert;

            await context.SaveChangesAsync();

            return Ok(await context.Rechnungshistorieeintrags.ToListAsync());
        }
    }
}

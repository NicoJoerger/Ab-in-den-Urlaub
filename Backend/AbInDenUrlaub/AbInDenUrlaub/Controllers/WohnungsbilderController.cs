using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AbInDenUrlaub.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class WohnungsbilderController : ControllerBase
    {
        private readonly Projekt1Context context;

        public WohnungsbilderController(Projekt1Context context)
        {
            this.context = context;
        }

        [HttpGet("{fwID}")]
        public async Task<ActionResult<List<Wohnungsbilder>>> GetBilderbyID(int fwID)
        {
            List<Wohnungsbilder> bilder = await context.Wohnungsbilders.ToListAsync();

            List<Wohnungsbilder> wbilder = new();

            foreach (var item in bilder)
            {
                if (item.FwId == fwID)
                {
                    wbilder.Add(item);
                }
            }

            List<Bilder> WbilderList = new();
            foreach (var item in wbilder)
            {
                Bilder temp = await context.Bilders.FindAsync(item.BildId);
                if (temp != null)
                {
                    WbilderList.Add(temp);
                }

            }

            return Ok(WbilderList);
        }
    }
}

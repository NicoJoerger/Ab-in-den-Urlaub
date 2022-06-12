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


            return Ok(wbilder);
        }

        [HttpPost]
        public async Task<ActionResult<List<Wohnungsbilder>>> AddWB(Wohnungsbilder newBild)
        {

            context.Wohnungsbilders.Add(newBild);

            await context.SaveChangesAsync();

            return Ok(newBild);
        }

        [HttpPut("{wbID}")]
        public async Task<ActionResult<List<Wohnungsbilder>>> AddBild(IFormFile newImage, int wbID)
        {
            await using var memStream = new MemoryStream();
            await newImage.CopyToAsync(memStream);
            await memStream.FlushAsync();
            Wohnungsbilder wBild = await context.Wohnungsbilders.FindAsync(wbID);
            wBild.bild = memStream.ToArray();

            await context.SaveChangesAsync();
            return Ok(wBild);
        }
    }
}

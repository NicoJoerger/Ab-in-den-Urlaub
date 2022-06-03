using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AbInDenUrlaub.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BilderController : ControllerBase
    {

        private readonly Projekt1Context context;

        public BilderController(Projekt1Context context)
        {
            this.context = context;
        }


        [HttpGet]
        public async Task<ActionResult<List<Bilder>>> GetBilder()
        {
            return Ok(await context.Bilders.ToListAsync());
        }

        [HttpPost]
        public async Task<ActionResult<IList<Bilder>>> AddBild(IList<IFormFile> newImages)
        {
            foreach (var f in newImages)
            {
                await AddImage(f);
            }

            await context.SaveChangesAsync();

            return Ok(await context.Bilders.ToListAsync());
        }

        async Task AddImage(IFormFile file)
        {
            await using var memStream = new MemoryStream();

            await file.CopyToAsync(memStream);
            await memStream.FlushAsync();
            Bilder newBild = new Bilder();
            newBild.Bild = memStream.ToArray();
            context.Bilders.Add(newBild);
        }
    }
}

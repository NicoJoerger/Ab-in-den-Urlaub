using Microsoft.AspNetCore.Mvc;
using System.Data.Entity;

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



    }
}

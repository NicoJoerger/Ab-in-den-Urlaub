using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections;
using System.Collections.Generic;

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

        [HttpPost]
        public async Task<ActionResult<List<Bilder>>> AddBild(System.Drawing.Image bild)
        {

            MemoryStream memoryStream = new MemoryStream();
            bild.Save(memoryStream, bild.RawFormat);
            byte[] buffer = memoryStream.ToArray();
            Bilder  newBild = new Bilder(); 
            newBild.Bild = buffer;
            context.Bilders.Add(newBild);
            await context.SaveChangesAsync();
           

            return Ok(await context.Bilders.ToListAsync());
        }
    }
}

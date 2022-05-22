﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AbInDenUrlaub.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AngeboteController : ControllerBase
    {
        private readonly Projekt1Context context;

        public AngeboteController(Projekt1Context context)
        {
            this.context = context;
        }

        [HttpGet]
        public async Task<ActionResult<List<Angebote>>> Get()
        {
            return Ok(await context.Angebotes.ToListAsync());
        }


        [HttpGet("{id}/a")]
        public async Task<ActionResult<List<Angebote>>> GetByAngID(int id)
        {
            List<Angebote> angebotes = await context.Angebotes.ToListAsync();

            List<Angebote> list = new();

            foreach (Angebote angebot in angebotes)
            {
                if(angebot.AngebotId == id)
                {
                    list.Add(angebot);
                }
            }

            return Ok(list);
        }


        [HttpGet("{id}/fw")]
        public async Task<ActionResult<List<Angebote>>> GetByAngFW(int id)
        {
            List<Angebote> angebotes = await context.Angebotes.ToListAsync();

            List<Angebote> list = new();

            foreach (Angebote angebot in angebotes)
            {
                if (angebot.FwId == id)
                {
                    list.Add(angebot);
                }
            }

            return Ok(list);
        }

        [HttpPost]
        public async Task<ActionResult<List<Angebote>>> AddAngebot(Angebote newAngebot)
        {
            context.Add(newAngebot);
            await context.SaveChangesAsync();

            return Ok(await context.Angebotes.ToListAsync());

        }

        [HttpPut]
        public async Task<ActionResult<List<Angebote>>> UpdateAngebot(Angebote updatedAngebot)
        {
            var dbAngebot = await context.Angebotes.FindAsync(updatedAngebot.FwId);
            if(dbAngebot == null)
            {
                return BadRequest("Angebot not found");
            }

            dbAngebot.MietzeitraumStart = updatedAngebot.MietzeitraumStart;
            dbAngebot.MietzeitraumEnde = updatedAngebot.MietzeitraumEnde;
            dbAngebot.AuktionEnddatum = updatedAngebot.AuktionEnddatum;
            dbAngebot.AktuellerTokenpreis = updatedAngebot.AktuellerTokenpreis;
            dbAngebot.Mietpreis = updatedAngebot.Mietpreis;
            dbAngebot.Stornierbar = updatedAngebot.Stornierbar;

            await context.SaveChangesAsync();

            return Ok(await context.Angebotes.ToListAsync());
        }

       
    }
}

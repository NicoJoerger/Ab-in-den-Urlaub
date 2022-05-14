﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AbInDenUrlaub.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KreditkartendatenController : ControllerBase
    {

        private readonly Projekt1Context context;

        public KreditkartendatenController(Projekt1Context context)
        {
            this.context = context;
        }

        [HttpGet]
        public async Task<ActionResult<List<Kreditkartendaten>>> Get()
        {
            return Ok(await context.Kreditkartendatens.ToListAsync());
        }

        [HttpPost]
        public async Task<ActionResult<List<Kreditkartendaten>>> AddKreditKarte(Kreditkartendaten kreditkarte)
        {
            context.Kreditkartendatens.Add(kreditkarte);
            await context.SaveChangesAsync();

            return Ok(await context.Kreditkartendatens.ToListAsync());
        }
    }
}

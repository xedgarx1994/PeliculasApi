﻿using AutoMapper;
using back_end.DTOs;
using back_end.Entidades;
using back_end.Filtros;
using back_end.Utilidades;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace back_end.Controllers
{
    [Route("api/generos")]
    [ApiController]
    //[Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    public class GenerosController: ControllerBase
    {
        //private readonly IRepositorio repositorio;
        //private readonly WeatherForecastController weatherForecastController;
        private readonly ILogger<GenerosController> logger;
        private readonly ApplicationDbContext context;
        private readonly IMapper mapper;

        public GenerosController( 
            ILogger<GenerosController> logger,
            ApplicationDbContext context, 
            IMapper mapper)
        {
            //this.repositorio = repositorio;
            this.logger = logger;
            this.context = context;
            this.mapper = mapper;
        }

        [HttpGet]// api/generos
        //[HttpGet("listado")] // api/generos/listado
        //[HttpGet("/listadogeneros")] //Listado de generos

        ////[ResponseCache(Duration = 60)] //filtro para get
        //[ServiceFilter(typeof(MiFiltroDeAccion))]
        public async Task<ActionResult<List<GeneroDTO>>> Get([FromQuery] PaginacionDTO paginacionDTO)
        {
            var queryable = context.Generos.AsQueryable();
            await HttpContext.InsertarParametrosPaginacionEnCabecera(queryable);

            var generos = await queryable.OrderBy(x => x.Nombre).Paginar(paginacionDTO).ToListAsync();

            //var generos = queryable.OrderBy(x => x.Nombre).Paginar(paginacionDTO).ToListAsync();
            return mapper.Map<List<GeneroDTO>>(generos);
        }
        ///*[HttpGet("guid")] //api/g*/eneros/guid
        //public ActionResult<Guid> GetGUID()
        //{
        //    return Ok(new
        //    {
        //        GUID_GenerosController = repositorio.ObtenerGUID(),
        //        //GUID_WeatherForecastController = weatherForecastController.ObtenerGUIDWeatherForecastController()
        //    });
        //}

        [HttpGet("{Id:int}")]
        public async Task<ActionResult<GeneroDTO>> Get(int Id)
        {
            var genero = await context.Generos.FirstOrDefaultAsync(x => x.Id == Id);

            if(genero == null)
            {
                return NotFound();
            }

            return mapper.Map<GeneroDTO>(genero);
        }

        [HttpPost]
        public async Task<ActionResult> Post([FromBody] GeneroCreacionDTO generoCreacionDTO)
        {
            //repositorio.CrearGenero(genero);
            //return NoContent();
            var genero = mapper.Map<Genero>(generoCreacionDTO);
            context.Add(genero);
            await context.SaveChangesAsync();
            return NoContent();
        }

        [HttpPut("{id:int}")]
        public async Task<ActionResult> Put(int Id, [FromBody] GeneroCreacionDTO generoCreacionDTO)
        {
            //return NoContent();
            //    throw new NotImplementedException();
            var genero = await context.Generos.FirstOrDefaultAsync(x => x.Id == Id);

            if (genero == null)
            {
                return NotFound();
            }
            genero = mapper.Map(generoCreacionDTO, genero);

            await context.SaveChangesAsync();
            return NoContent();
        }
        [HttpDelete("{id:int}")]
        public async Task<ActionResult> Delete(int id)
        {
            //return NoContent();
            //throw new NotImplementedException();
            var existe = await context.Generos.AnyAsync(x => x.Id == id);

            if(!existe)
            {
                return NotFound();
            }
            context.Remove(new Genero() { Id = id });
            await context.SaveChangesAsync();
            return NoContent();
        }
    }
}

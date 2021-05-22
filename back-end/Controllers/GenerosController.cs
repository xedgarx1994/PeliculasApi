using AutoMapper;
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
        public async Task<ActionResult<Genero>> Get(int Id)
        {
            throw new NotImplementedException();
            //logger.LogDebug($"Obteniendo un género por el Id: {Id}");
            //var genero = await repositorio.ObtenerPorId(Id);
            //if(genero == null)
            //{
            //    //throw new ApplicationException($"El genero de ID {Id} no fue encontrado");
            //    logger.LogWarning($"No se pudo encontrar el género de id: {Id}");
            //    return NotFound();
            //}
            //// return ok("Felipe") permite retornar lo que sea, pero el problema es que no sabemos que va enviar
            //return genero;
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

        [HttpPut]
        public ActionResult Put()
        {
            //return NoContent();
            throw new NotImplementedException();
        }
        [HttpDelete]
        public ActionResult Delete()
        {
            //return NoContent();
            throw new NotImplementedException();
        }
    }
}

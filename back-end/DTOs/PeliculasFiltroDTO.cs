using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace back_end.DTOs
{
    public class PeliculasFiltroDTO
    {
        public int Pagina { get; set; }
        public int RecordsPorPagina { get; set; }
        public PaginacionDTO PaginacionDTO
        {
            get
            {
                return new PaginacionDTO() { Pagina = Pagina, RecordPorPagina = RecordsPorPagina };
            }
        }
        public string Titulo { get; set; }
        public int GeneroId { get; set; }
        public bool EnCines { get; set; }
        public bool ProximosEstrenos { get; set; }
    }
}

﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace back_end.DTOs
{
    public class PeliculasPutGetDTO
    {
        public PeliculaDTO pelicula { get; set; }
        public List<GeneroDTO> GenerosSeleccionados { get; set; }
        public List<GeneroDTO> GenerosNoSeleccionados { get; set; }
        public List<CineDTO> CinesSeleccionados { get; set; }
        public List<CineDTO> CinesNoSeleccionados { get; set; }
        public List<PeliculaActorDTO> Actores { get; set; }

    }
}

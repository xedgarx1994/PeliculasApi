using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace back_end.DTOs
{
    public class RatingDTO
    {
        public int PeliculaId { get; set; }
        [Range(1,5)]
        public int Puntuacion { get; set; }

        //NO SE CREA EL ID DEL USUARIO YA QUE ES UNA VULNARIBILIDAD PARA EL SISTEMA ESO LO TOMAMOS DEL TOKEN
    }
}

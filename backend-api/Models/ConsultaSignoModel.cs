using System;
using System.ComponentModel.DataAnnotations;

namespace backend_api.Models
{
    public class ConsultaSignoModel
    {
        [Required]
        public string? NomeSigno { get; set; }

        [Required]
        public DateTime Data { get; set; }
    }

    public class RespostaSignoModel
    {
        public string? Conteudo { get; set; }
    }
}
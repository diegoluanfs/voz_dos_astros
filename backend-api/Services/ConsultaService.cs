using System;
using backend_api.Models;

namespace backend_api.Services
{
    public class ConsultaSignoService
    {
        public RespostaSignoModel ConsultarSigno(ConsultaSignoModel consulta)
        {
            // Simulação de resposta baseada no signo e data
            return new RespostaSignoModel
            {
                Conteudo = $"Previsão para {consulta.NomeSigno} em {consulta.Data:dd/MM/yyyy}: Você terá um ótimo dia!"
            };
        }
    }
}
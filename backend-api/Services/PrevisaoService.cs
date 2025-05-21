using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using backend_api.Models;

namespace backend_api.Services
{
    public class PrevisaoService
    {
        private readonly OpenAiService _openAiService;

        public PrevisaoService(OpenAiService openAiService)
        {
            _openAiService = openAiService;
        }

        public async Task<List<RespostaSignoModel>> GerarPrevisoesAnoAsync(string nomeSigno, int ano)
        {
            var previsoes = new List<RespostaSignoModel>();
            var data = new DateTime(ano, 1, 1);
            var fim = new DateTime(ano, 12, 31);

            while (data <= fim)
            {
                var conteudo = await _openAiService.GerarPrevisaoAsync(nomeSigno, data);
                previsoes.Add(new RespostaSignoModel
                {
                    Conteudo = conteudo
                });
                data = data.AddDays(1);
            }

            // Aqui você pode persistir no banco, se desejar

            return previsoes;
        }
    }
}
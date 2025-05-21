using Microsoft.AspNetCore.Mvc;
using backend_api.Models;
using backend_api.Services;

namespace backend_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ConsultaSignoController : ControllerBase
    {
        private readonly ConsultaSignoService _service;

        public ConsultaSignoController()
        {
            _service = new ConsultaSignoService();
        }

        [HttpPost]
        public ActionResult<RespostaSignoModel> ConsultarSigno([FromBody] ConsultaSignoModel consulta)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var resposta = _service.ConsultarSigno(consulta);
            return Ok(resposta);
        }
    }
}
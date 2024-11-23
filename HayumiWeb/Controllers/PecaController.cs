using HayumiWeb.Models;
using HayumiWeb.Repositorio;
using Microsoft.AspNetCore.Mvc;

namespace HayumiWeb.Controllers
{
    public class PecaController : Controller
    {
        private IPecaRepositorio _IPecaRepositorio;

        public PecaController(IPecaRepositorio pecaRepositorio)
        {
            _IPecaRepositorio = pecaRepositorio;
        }
        public IActionResult Index(int? categoriaId, string? pesquisa)
        {
            ViewBag.UsuarioNome = HttpContext.Session.GetString("UsuarioNome");

            if (categoriaId != null)
            {
                List<PecaModel> peca = _IPecaRepositorio.BuscarPecaPorCategoria(categoriaId.Value);

                return View(new PecaViewModel { Pecas = peca });
            }

            if (pesquisa != null)
            {
                List<PecaModel> peca = _IPecaRepositorio.BuscarPecaPorNome(pesquisa);

                return View(new PecaViewModel { Pecas = peca });
            }

            List<PecaModel> todasAsPecas = _IPecaRepositorio.BuscarTodasAsPecas();

            return View(new PecaViewModel { Pecas = todasAsPecas });
        }

        public IActionResult Detalhes(int pecaId)
        {
            ViewBag.UsuarioNome = HttpContext.Session.GetString("UsuarioNome");
            var peca = _IPecaRepositorio.BuscarPecaPorId(pecaId);
            return View(peca);
        }
    }
}

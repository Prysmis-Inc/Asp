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
        public IActionResult Index(int categoriaId)
        {
            ViewBag.UsuarioNome = HttpContext.Session.GetString("UsuarioNome");
            List<PecaModel> peca = _IPecaRepositorio.BuscarPecaPorCategoria(categoriaId);
            return View(new PecaViewModel { Pecas = peca });
        }
    }
}

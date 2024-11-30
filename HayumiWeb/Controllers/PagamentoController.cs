using HayumiWeb.Models;
using HayumiWeb.Repositorio;
using Microsoft.AspNetCore.Mvc;

namespace HayumiWeb.Controllers
{
    public class PagamentoController : Controller
    {
        private readonly IPedidoRepositorio _pedidoRepositorio;

        public PagamentoController(IPedidoRepositorio pedidoRepositorio)
        {
            _pedidoRepositorio = pedidoRepositorio;
        }

        public IActionResult Pagamento(int pedidoId)
        {
            ViewBag.UsuarioNome = HttpContext.Session.GetString("UsuarioNome");
            var pedido = _pedidoRepositorio.BuscaPedidoPorId(pedidoId);

            return View(new PagamentoViewModel
            {
                Pedido = pedido
            });
        }
        
        public IActionResult Pix() 
        {
            return View(); 
        }

        public IActionResult Cartao() 
        { 
            return View();
        }

        public IActionResult Boleto() 
        { 
            return View(); 
        }
    }
}

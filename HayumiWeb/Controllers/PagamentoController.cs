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
            // Aqui você pode carregar as informações do pedido e permitir que o cliente faça o pagamento
            ViewBag.PedidoId = pedidoId;

            var pedido = _pedidoRepositorio.BuscaPedidoPorId(pedidoId);

            return View(new PagamentoViewModel
            {
                Pedido = pedido
            });
        }
    }
}

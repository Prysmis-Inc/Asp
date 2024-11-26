using Microsoft.AspNetCore.Mvc;

namespace HayumiWeb.Controllers
{
    public class PagamentoController : Controller
    {
        public IActionResult Pagamento(int? pedidoId)
        {
            // Aqui você pode carregar as informações do pedido e permitir que o cliente faça o pagamento
            ViewBag.PedidoId = pedidoId;
            return View();
        }
    }
}

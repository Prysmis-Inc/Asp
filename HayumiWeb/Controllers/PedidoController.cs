using HayumiWeb.Repositorio;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace HayumiWeb.Controllers
{
    public class PedidoController : Controller
    {
        private readonly IPedidoRepositorio _pedidoRepositorio;
        private readonly ILogger<PedidoController> _logger;
        public PedidoController(IPedidoRepositorio pedidoRepositorio, ILogger<PedidoController> logger) 
        {
            _pedidoRepositorio = pedidoRepositorio;
            _logger = logger;
        }

        [HttpPost]
        public IActionResult FinalizarPedido()
        {
            // Recupera o ClienteId da sessão
            int? clienteId = HttpContext.Session.GetInt32("ClienteId");

            // Verifica se o cliente está logado
            if (clienteId == null)
            {
                // Se o cliente não estiver logado, redireciona para a página de login
                return RedirectToAction("Login", "Home");
            }

            try
            {
                // Chama o repositório para finalizar o pedido
                int pedidoId = _pedidoRepositorio.FinalizarPedido(clienteId.Value);

                // Passa o ID do pedido para a View de confirmação de pagamento
                ViewBag.PedidoId = pedidoId;

                // Redireciona para a página de pagamento
                return RedirectToAction("Index", "Pagamento");
            }
            catch (Exception ex)
            {
                // Registra o erro
                _logger.LogError(ex, "Erro ao finalizar o pedido para o cliente ID: {ClienteId}", clienteId);
                TempData["Erro"] = "Erro ao finalizar o pedido: " + ex.Message;
                return RedirectToAction("Index", "Home");
            }
        }
    }
}

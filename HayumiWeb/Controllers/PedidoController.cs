using HayumiWeb.Repositorio;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace HayumiWeb.Controllers
{
    public class PedidoController : Controller
    {
        private readonly IPedidoRepositorio _pedidoRepositorio;
        private readonly ICarrinhoRepositorio _carrinhoRepositorio;
        public PedidoController(IPedidoRepositorio pedidoRepositorio, ICarrinhoRepositorio carrinhoRepositorio) 
        {
            _pedidoRepositorio = pedidoRepositorio;
            _carrinhoRepositorio = carrinhoRepositorio;
        }
        // Método para finalizar o pedido
        [HttpPost]
        public IActionResult FinalizarPedido()
        {
            int? clienteId = HttpContext.Session.GetInt32("ClienteId");
            if (clienteId == null)
            {
                // Se não encontrar o ClienteId, redireciona para a página de login
                return RedirectToAction("Login", "Account");
            }

            // Chama o repositório para inserir o pedido e obter o ID do pedido
            int pedidoId = _pedidoRepositorio.InserirPedido(clienteId.Value);

            // Verifica se o ID do pedido é válido
            if (pedidoId > 0)
            {
                TempData["Mensagem"] = $"Pedido {pedidoId} registrado com sucesso!";
            }
            else
            {
                TempData["Mensagem"] = "Houve um erro ao registrar o pedido.";
            }

            // Redireciona para a página de confirmação
            return RedirectToAction("Pagamento", "Pagamento", new { pedidoId });
        }

        [HttpPost]
        public IActionResult ConfirmarPedido(int pedidoId)
        {
            // Chama o método para confirmar o pedido
            int resultado = _pedidoRepositorio.ConfirmarPedido(pedidoId);

            // Verifica se o retorno é válido (pedido confirmado)
            if (resultado > 0)
            {
                TempData["Mensagem"] = $"Pedido {resultado} confirmado com sucesso!";
            }
            else
            {
                TempData["Mensagem"] = "Erro ao confirmar o pedido.";
            }

            // Redireciona para a página de pagamento
            return RedirectToAction("Index", "Pagamento", new { id = pedidoId });
        }

    }
}

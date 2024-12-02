using HayumiWeb.Models;
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
                return RedirectToAction("Login", "Home");
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

       

        public IActionResult ExibirPedidos(int clienteId)
        {
            ViewBag.UsuarioNome = HttpContext.Session.GetString("UsuarioNome");
            int? sclienteId = HttpContext.Session.GetInt32("ClienteId");
            // Recupera os pedidos do cliente
            var pedidos = _pedidoRepositorio.BuscaPedidoPorCliente(sclienteId.Value); // Chama o repositório para buscar os pedidos

            // Cria o PedidoViewModel com a lista de pedidos
            var pedidoViewModel = new PedidoViewModel
            {
                Pedidos = pedidos // Atribui a lista de pedidos ao modelo
            };

            // Verifica se não encontrou pedidos
            if (pedidoViewModel.Pedidos == null || !pedidoViewModel.Pedidos.Any())
            {
                ViewBag.Mensagem = "Nenhum pedido encontrado para este cliente.";
            }

            return View(pedidoViewModel); // Passa o modelo para a view
        }


        public IActionResult ExibirDetalhes(int id)  // O "id" vai ser o pedidoId passado pela URL
        {
            ViewBag.UsuarioNome = HttpContext.Session.GetString("UsuarioNome");
            var pedido = _pedidoRepositorio.BuscaPedidoPorId(id);

            // Verifica se o pedido foi encontrado
            if (pedido == null)
            {
                TempData["Mensagem"] = "Pedido não encontrado!";
                return RedirectToAction("ExibirPedidos"); // Redireciona para a lista de pedidos caso não encontre
            }

            // Passa o pedido para a View
            return View(new PagamentoViewModel
            {
                Pedido = pedido
            }); 
         }

        
    }
}


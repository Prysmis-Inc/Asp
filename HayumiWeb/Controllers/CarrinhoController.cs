using Microsoft.AspNetCore.Mvc;
using HayumiWeb.Models;
using HayumiWeb.Repositorio;

namespace HayumiWeb.Controllers
{
    public class CarrinhoController : Controller
    {
        private readonly ICarrinhoRepositorio _carrinhoRepositorio;
        private readonly IPedidoRepositorio _pedidoRepositorio;

        public CarrinhoController(ICarrinhoRepositorio carrinhoRepositorio, IPedidoRepositorio pedidoRepositorio)
        {
            _carrinhoRepositorio = carrinhoRepositorio;
            _pedidoRepositorio = pedidoRepositorio;
        }

        // Exibe os itens do carrinho de compras para o cliente
        public IActionResult Index()
        {
            // Recupera o ClienteId da sessão
            int? clienteId = HttpContext.Session.GetInt32("ClienteId");
            ViewBag.UsuarioNome = HttpContext.Session.GetString("UsuarioNome");
            if (clienteId == null)
            {
                return RedirectToAction("Login", "Home"); // Redireciona para a página de login
            }

            // Lista os itens do carrinho de compras
            var itensCarrinho = _carrinhoRepositorio.ListarCarrinho(clienteId.Value);
            return View(itensCarrinho); // Retorna a view com os itens do carrinho
        }

        // Adiciona um item ao carrinho de compras
        [HttpPost]
        public IActionResult Adicionar(int pecaId, int quantidade)
        {
            // Recupera o ClienteId da sessão
            int? clienteId = HttpContext.Session.GetInt32("ClienteId");

            if (clienteId == null)
            {
                return RedirectToAction("Login", "Home"); // Redireciona para a página de login se não estiver autenticado
            }

            // Chama o método para adicionar o item ao carrinho no repositório
            _carrinhoRepositorio.AdicionarItem(clienteId.Value, pecaId, quantidade);

            // Redireciona para a página do carrinho de compras após adicionar o produto
            return RedirectToAction("Index", "Carrinho"); // Ação "Index" do CarrinhoController
        }

        // Remove um item do carrinho de compras
        public IActionResult Remover(int pecaId)
        {
            // Recupera o ClienteId da sessão
            int? clienteId = HttpContext.Session.GetInt32("ClienteId");

            if (clienteId == null)
            {
                return RedirectToAction("Login", "Home"); // Redireciona para a página de login
            }

            // Remove o item do carrinho
            _carrinhoRepositorio.RemoverItem(clienteId.Value, pecaId);
            return RedirectToAction("Index"); // Redireciona para a página do carrinho
        }

        // Atualiza a quantidade de um item no carrinho
        [HttpPost]
        public IActionResult AtualizarQuantidade(int pecaId, int quantidade)
        {
            // Recupera o ClienteId da sessão
            int? clienteId = HttpContext.Session.GetInt32("ClienteId");

            if (clienteId == null)
            {
                return RedirectToAction("Login", "Home"); // Redireciona para a página de login
            }

            // Atualiza a quantidade do item no carrinho
            _carrinhoRepositorio.AtualizarQuantidade(clienteId.Value, pecaId, quantidade);
            return RedirectToAction("Index"); // Redireciona para a página do carrinho
        }

        [HttpPost]
        public IActionResult FinalizarPedido()
        {
            // Recupera o ClienteId da sessão
            int? clienteId = HttpContext.Session.GetInt32("ClienteId");

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
                return RedirectToAction("Pagamento", "Pagamento");
            }
            catch (Exception ex)
            {
                // Em caso de erro, pode exibir uma mensagem de erro ou logar o erro
                TempData["Erro"] = "Erro ao finalizar o pedido: " + ex.Message;
                return RedirectToAction("Index", "Home"); // Volta para o carrinho em caso de erro
            }
        }
    }
}

using HayumiWeb.Models;
using HayumiWeb.Repositorio;
using Microsoft.AspNetCore.Mvc;

namespace HayumiWeb.Controllers
{
    public class PagamentoController : Controller
    {
        private readonly IPedidoRepositorio _pedidoRepositorio;
        private readonly IPagamentoRepositorio _pagamentoRepositorio;

        public PagamentoController(IPedidoRepositorio pedidoRepositorio, IPagamentoRepositorio pagamentoRepositorio)
        {
            _pedidoRepositorio = pedidoRepositorio;
            _pagamentoRepositorio = pagamentoRepositorio;
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

        [HttpPost]
        public IActionResult Pagamento(PagamentoViewModel pagamentoViewModel)
        {
            var action = "";

            if (pagamentoViewModel.FormaPagamento == "Pix")
            {
                action = "Pix";
            }
            if (pagamentoViewModel.FormaPagamento == "Credito" || pagamentoViewModel.FormaPagamento == "Debito")
            {
                action = "Cartao";
            }
            if (pagamentoViewModel.FormaPagamento == "Boleto")
            {
                action = "Boleto";
            }

            return RedirectToAction(action, pagamentoViewModel);
        }

        private string GerarChavePix()
        {
            var random = new Random();
            const string caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            var chavePix = new char[32];

            for (int i = 0; i < chavePix.Length; i++)
            {
                chavePix[i] = caracteres[random.Next(caracteres.Length)];
            }

            return new string(chavePix);
        }
        public IActionResult Pix(PagamentoViewModel pagamentoViewModel)
        {
            pagamentoViewModel.ChavePix = GerarChavePix();
            return View(pagamentoViewModel);
        }

        public IActionResult Cartao(PagamentoViewModel pagamentoViewModel) 
        { 
            return View(pagamentoViewModel);
        }
        private string GerarCodigoBoleto()
        {
            var random = new Random();

            // Simula um código de boleto com um formato básico
            // Este código tem uma estrutura com banco, valor e vencimento fictícios
            string codigoBoleto = string.Format("{0:D4} {1:D4} {2:D4} {3:D4} {4:D4} {5:D4} {6:D4} {7:D4}",
                random.Next(1000, 9999),   // Banco
                random.Next(1000, 9999),   // Agência
                random.Next(1000, 9999),   // Conta
                random.Next(1000, 9999),   // Código do título
                random.Next(1000, 9999),   // Valor
                random.Next(1000, 9999),   // Data de vencimento
                random.Next(1000, 9999),   // Nosso número
                random.Next(1000, 9999)    // Código de barras fictício
            );

            return codigoBoleto;
        }
        public IActionResult Boleto(PagamentoViewModel pagamentoViewModel) 
        {
            pagamentoViewModel.CodigoBoleto = GerarCodigoBoleto();
            return View(pagamentoViewModel); 
        }

        public IActionResult PagarPedido(PagamentoViewModel pagamentoViewModel)
        {
            var pedido = _pedidoRepositorio.BuscaPedidoPorId(pagamentoViewModel.PedidoId);

            _pagamentoRepositorio.Pagar(new PagamentoModel
            {
                PedidoId = pagamentoViewModel.PedidoId,
                ValorPago =  pedido.Itens.Sum(c => c.ValorTotal),
                DataPagamento = DateTime.Now,
                TipoPagamento = pagamentoViewModel.FormaPagamento,
                NomeTitular = pagamentoViewModel.NomeTitular,
                BandeiraCartao = pagamentoViewModel.BandeiraCartao,
                NumeroCartao = pagamentoViewModel.NumeroCartao,
                CVV = pagamentoViewModel.CVV,
                DataValidade = pagamentoViewModel.DataValidade,
            }); 

            return View();
        }

        public IActionResult PagamentoSucces()
        {
            return View();
        }
    }
}

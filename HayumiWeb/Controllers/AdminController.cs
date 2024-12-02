using HayumiWeb.Models;
using HayumiWeb.Repositorio;
using Microsoft.AspNetCore.Mvc;

namespace HayumiWeb.Controllers
{
    public class AdminController : Controller
    {
        private readonly IWebHostEnvironment _webHostEnvironment;
        private IClienteRepositorio? _clienteRepositorio;
        private ICategoriaRepositorio? _categoriaRepositorio;
        private IPecaRepositorio? _pecaRepositorio;
        private ICarrinhoRepositorio? _carrinhoRepositorio;
        private IPedidoRepositorio? _pedidoRepositorio;
        public AdminController(IClienteRepositorio clienteRepositorio, ICategoriaRepositorio? categoriaRepositorio, IPecaRepositorio? pecaRepositorio, ICarrinhoRepositorio? carrinhoRepositorio, IPedidoRepositorio? pedidoRepositorio, IWebHostEnvironment webHostEnvironment)
        {
            _clienteRepositorio = clienteRepositorio;
            _categoriaRepositorio = categoriaRepositorio;
            _pecaRepositorio = pecaRepositorio;
            _carrinhoRepositorio = carrinhoRepositorio;
            _pedidoRepositorio = pedidoRepositorio;
            _webHostEnvironment = webHostEnvironment;
        }

        public IActionResult Index()
        {
            return View();
        }
        public IActionResult BuscarClientes()
        {
            List<ClienteModel> clientes = _clienteRepositorio.BuscarTodosClientes();
            return View(clientes);
        }

 
        public IActionResult MostrarCategorias() 
        {
            List<CategoriaModel> categorias = _categoriaRepositorio.BuscarCategorias();
            return View(categorias);
        }

        public IActionResult MostrarPecasCategorias() 
        {
            List<PecaModel> pecas = _pecaRepositorio.BuscarPecaCategorias();
            return View(pecas);
        }

        public IActionResult MostrarCarrinhos()
        {
            List<CarrinhoCompra> carros = _carrinhoRepositorio.MostrarCarros();
            return View(carros);
        }


        public IActionResult PedidosM() 
        {
            List<PedidoModel> pedidos = _pedidoRepositorio.MostrarPedidos();
            return View(pedidos);
        }

        [HttpGet]
        public IActionResult AdicionarPeca() 
        {
            return View();
        }

        [HttpPost]
        public IActionResult AdicionarPeca(PecaViewModel model)
        {
            var uploadsFolder = Path.Combine(_webHostEnvironment.WebRootPath, "img");

            var fileName = Path.GetFileName(model.ImagemFormFile.FileName);
            var filePath = Path.Combine(uploadsFolder, fileName);

            // Save the file to the server
            using (var fileStream = new FileStream(filePath, FileMode.Create))
            {
                model.ImagemFormFile.CopyTo(fileStream);
            }

            model.Peca.ImgPeca = model.ImagemFormFile.FileName;

            _clienteRepositorio.InserirPeca(model.Peca);

            // Redireciona para a página de listagem ou exibe uma mensagem de sucesso
            return RedirectToAction("Index", "Admin");
        }



        [HttpGet]
        public IActionResult CriarCategoria()
        {
            return View();
        }

        [HttpPost]
        public IActionResult CriarCategoria(CategoriaModel categoria)
        {
            _clienteRepositorio.InserirCategoria(categoria);
            return RedirectToAction("Index", "Admin");
        }

        public IActionResult EditarPeca(int pecaId)
        { 
            var peca = _pecaRepositorio.BuscarPecaPorId(pecaId);

            return View(new PecaViewModel
            {
                Peca = peca
            });
        }

        [HttpPost]
        public IActionResult EditarPeca(PecaViewModel model)
        {
            if (model.ImagemFormFile != null)
            {
                var uploadsFolder = Path.Combine(_webHostEnvironment.WebRootPath, "img");

                var fileName = Path.GetFileName(model.ImagemFormFile.FileName);
                var filePath = Path.Combine(uploadsFolder, fileName);

                // Save the file to the server
                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    model.ImagemFormFile.CopyTo(fileStream);
                }

                model.Peca.ImgPeca = model.ImagemFormFile.FileName;
            }

            // Trocar pra update
            _clienteRepositorio.InserirPeca(model.Peca);

            // Redireciona para a página de listagem ou exibe uma mensagem de sucesso
            return RedirectToAction("Index", "Admin");
        }

        public IActionResult EditarCategoria()
        {
            return View();
        }
    }
    
}

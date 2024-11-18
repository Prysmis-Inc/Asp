using HayumiWeb.Libraries.Login;
using HayumiWeb.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using HayumiWeb.Repositorio;
using Newtonsoft.Json;
using System.Diagnostics.Eventing.Reader;
using MySqlX.XDevAPI;

namespace HayumiWeb.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private IClienteRepositorio? _clienteRepositorio;
        private ICategoriaRepositorio _categoriaRepositorio;
        private LoginCliente _loginCliente;

        public HomeController(ILogger<HomeController> logger, IClienteRepositorio clienteRepositorio, ICategoriaRepositorio categoriaRepositorio, LoginCliente loginCliente)
        {
            _logger = logger;
            _clienteRepositorio = clienteRepositorio;
            _categoriaRepositorio = categoriaRepositorio;
            _loginCliente = loginCliente;
        }

        public IActionResult Index()
        {
            ViewBag.UsuarioNome = HttpContext.Session.GetString("UsuarioNome");

            List<CategoriaModel> categorias = _categoriaRepositorio.BuscarCategorias();

            return View(new HomeViewModel
            {
                Categorias = categorias
            });
        }

        public IActionResult Login()
        {

            return View();
        }

        [HttpPost]
        public IActionResult Login(ClienteModel cliente)
        {
            ClienteModel loginDB = _clienteRepositorio.Login(cliente.Email, cliente.SenhaUsu, cliente.ClienteId);

            if (loginDB.Email != null && loginDB.SenhaUsu != null)
            {
                _loginCliente.Login(loginDB);
                HttpContext.Session.SetString("UsuarioNome", loginDB.Email);
                HttpContext.Session.SetInt32("ClienteId", loginDB.ClienteId);
                return new RedirectResult(Url.Action(nameof(Index)));
            }
            else
            {
                //Erro na sess�o
                ViewData["msg"] = "Usu�rio inv�lido, verifique e-mail e senha";
                return View();
            }

        }

        [HttpGet]
        public IActionResult Cadastro()
        {

            return View();
        }

        [HttpPost]
        public IActionResult Cadastro(ClienteModel cliente)
        {
            if (ModelState.IsValid)
            {
                return View();
            }
            if (cliente.ClienteStatus == null)
            {
                cliente.ClienteStatus = false; // Define o valor padr�o como false
            }

            _clienteRepositorio.Cadastrar(cliente); // Salva o cliente no banco de dados
            return RedirectToAction(nameof(Login));
        }




        public IActionResult Perfil()
        {
            // Recupera o ClienteId da sess�o
            int? clienteId = HttpContext.Session.GetInt32("ClienteId");
            ViewBag.UsuarioNome = HttpContext.Session.GetString("UsuarioNome");
            if (clienteId == null)
            {
                // Se n�o encontrar o ClienteId, redireciona para a p�gina de login
                return RedirectToAction("Login", "Account");
            }

            // Busca os dados do cliente usando o ClienteId
            var cliente = _clienteRepositorio.BuscarClientePorId(clienteId.Value);

            if (cliente == null)
            {
                // Se n�o encontrar o cliente, redireciona para a p�gina de erro ou login
                return RedirectToAction("Erro", "Home");
            }

            // Retorna a view com os dados do cliente
            return View(cliente);
        }







        [HttpGet]
        public IActionResult Editar()
        {
            // Recupere o ClienteId da sess�o
            int? clienteId = HttpContext.Session.GetInt32("ClienteId");
            ViewBag.UsuarioNome = HttpContext.Session.GetString("UsuarioNome");
            if (clienteId == null)
            {
                // Se o ClienteId n�o existir na sess�o, redireciona para o login
                return RedirectToAction("Login", "Account");
            }

            // Busca os dados do cliente pelo ID
            var cliente = _clienteRepositorio.BuscarClientePorId(clienteId.Value);

            if (cliente == null)
            {
                // Se n�o encontrar o cliente, redireciona para a p�gina de erro
                return RedirectToAction("Erro", "Home");
            }

            // Retorna a view de edi��o com os dados do cliente
            return View(cliente);
        }

        // A��o POST para salvar as altera��es do cliente
        [HttpPost]
        public IActionResult Editar(ClienteModel cliente)
        {
            if (ModelState.IsValid)
            {
                _clienteRepositorio.Alterar(cliente);  // Atualiza as informa��es do cliente
                return RedirectToAction("Perfil");  // Redireciona para o perfil ap�s sucesso
            }
            ViewBag.UsuarioNome = HttpContext.Session.GetString("UsuarioNome");
            return View(cliente);  // Se o modelo n�o for v�lido, retorna para a view de edi��o
        }














        public IActionResult Logout()
        {
            HttpContext.Session.Clear();
            return RedirectToAction(nameof(Login));
        }







        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}

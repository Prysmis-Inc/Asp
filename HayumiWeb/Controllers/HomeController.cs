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
        private LoginCliente _loginCliente;

        public HomeController(ILogger<HomeController> logger, IClienteRepositorio clienteRepositorio, LoginCliente loginCliente)
        {
            _logger = logger;
            _clienteRepositorio = clienteRepositorio;
            _loginCliente = loginCliente;
        }

        public IActionResult Index()
        {
            return View();
        }
        public IActionResult Login()
        {

            return View();
        }
        [HttpPost]
        public IActionResult Login(ClienteModel cliente)
        {
            ClienteModel loginDB = _clienteRepositorio.Login(cliente.Email, cliente.Senha);

            if (loginDB.Email != null && loginDB.Senha != null)
            {
                _loginCliente.Login(loginDB);
                return new RedirectResult(Url.Action(nameof(Index)));
            }
            else
            {
                //Erro na sessão
                ViewData["msg"] = "Usuário inválido, verifique e-mail e senha";
                return View();
            }

        }
        public IActionResult Cadastro()
        {

            return View();
        }
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}

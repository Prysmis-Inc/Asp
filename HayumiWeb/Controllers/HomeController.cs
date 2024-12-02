using HayumiWeb.Libraries.Login;
using HayumiWeb.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using HayumiWeb.Repositorio;
using Newtonsoft.Json;
using System.Diagnostics.Eventing.Reader;
using MySqlX.XDevAPI;
using Microsoft.AspNetCore.Http;

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
            string statusString = HttpContext.Session.GetString("ClienteStatus");
            bool status = !string.IsNullOrEmpty(statusString) && bool.Parse(statusString);
            ViewBag.Status = status;

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
            var loginDB = _clienteRepositorio.Login(cliente.Email, cliente.SenhaUsu);
            // Verifica se o cliente foi encontrado e se o status é 'true'
            
            if (loginDB.ClienteStatus == true)
            {
                _loginCliente.Login(loginDB);
                // Realiza o login do cliente e redireciona para o painel de administração

                HttpContext.Session.SetString("UsuarioNome", loginDB.Email);
                HttpContext.Session.SetInt32("ClienteId", loginDB.ClienteId);
                HttpContext.Session.SetString("Adm", loginDB.ClienteStatus.ToString());

                // Redireciona para a página de administração (PainelAdm)
                return RedirectToAction("Index", "Admin");
            }
            if (loginDB.Email != null && loginDB.SenhaUsu != null)
            {
                _loginCliente.Login(loginDB);
                HttpContext.Session.SetString("UsuarioNome", loginDB.Email);
                HttpContext.Session.SetInt32("ClienteId", loginDB.ClienteId);
                return RedirectToAction("Index");
            }
            else
            {
                //Erro na sessão
                ViewData["msg"] = "Usuário inválido, verifique e-mail e senha";
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
            if (!ModelState.IsValid)
            {
                return View();
            }
            if (cliente.ClienteStatus == null)
            {
                cliente.ClienteStatus = false; // Define o valor padrão como false
            }

            _clienteRepositorio.Cadastrar(cliente); // Salva o cliente no banco de dados
            return RedirectToAction(nameof(Login));
        }




        public IActionResult Perfil()
        {
            // Recupera o ClienteId da sessão
            int? clienteId = HttpContext.Session.GetInt32("ClienteId");
            ViewBag.UsuarioNome = HttpContext.Session.GetString("UsuarioNome");
            if (clienteId == null)
            {
                // Se não encontrar o ClienteId, redireciona para a página de login
                return RedirectToAction("Login", "Account");
            }

            // Busca os dados do cliente usando o ClienteId
            var cliente = _clienteRepositorio.BuscarClientePorId(clienteId.Value);

            if (cliente == null)
            {
                // Se não encontrar o cliente, redireciona para a página de erro ou login
                return RedirectToAction("Erro", "Home");
            }

            // Retorna a view com os dados do cliente
            return View(cliente);
        }







        [HttpGet]
        public IActionResult Editar()
        {
            // Recupere o ClienteId da sessão
            int? clienteId = HttpContext.Session.GetInt32("ClienteId");
            ViewBag.UsuarioNome = HttpContext.Session.GetString("UsuarioNome");
            if (clienteId == null)
            {
                // Se o ClienteId não existir na sessão, redireciona para o login
                return RedirectToAction("Login", "Account");
            }

            // Busca os dados do cliente pelo ID
            var cliente = _clienteRepositorio.BuscarClientePorId(clienteId.Value);

            if (cliente == null)
            {
                // Se não encontrar o cliente, redireciona para a página de erro
                return RedirectToAction("Erro", "Home");
            }

            // Retorna a view de edição com os dados do cliente
            return View(cliente);
        }

        // Ação POST para salvar as alterações do cliente
        [HttpPost]
        public IActionResult Editar(ClienteModel cliente)
        {
            
                // Chama o método de atualização
                _clienteRepositorio.Alterar(cliente);  // Onde Alterar é o método que você implementou anteriormente.

                // Redireciona para uma página de sucesso ou para o perfil do cliente
                return RedirectToAction("Perfil", "Home");
            

            
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

using HayumiWeb.Models;
using HayumiWeb.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace HayumiWeb.Controllers
{
    public class ClienteController : Controller
    {
        private readonly IClienteRepository _clienteRepository;

        public ClienteController()
        {
            _clienteRepository = new ClienteRepository();
        }

        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Cadastro(ClienteModel clienteModel)
        {
            if (!ModelState.IsValid)
            {
                ViewData["MensagemErro"] = "Dados invalidos";

                return View("Index");
            }

            _clienteRepository.Cadastrar(clienteModel);

            return View("Index");
        }
    }
}

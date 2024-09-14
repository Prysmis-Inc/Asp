using MySqlX.XDevAPI;
using Newtonsoft.Json;
using HayumiWeb.Models;

namespace HayumiWeb.Libraries.Login
{
    public class LoginCliente
    {
        //injeção de dependência
        private string Key = "Login.Cliente";
        private Session.Session _sessao;

        //Construtor
        public LoginCliente(Session.Session sessao)
        {
            _sessao = sessao;
        }
        // método login 
        public void Login(ClienteModel cliente)
        {
            // Serializar- Com a serialização é possível salvar objetos em arquivos de dados
            string clienteJSONString = JsonConvert.SerializeObject(cliente);
        }

        public ClienteModel GetCliente()
        {
            /* Deserializar-Já a desserialização permite que os 
            objetos persistidos em arquivos possam ser recuperados e seus valores recriados na memória*/

            if (_sessao.Existe(Key))
            {
                string clienteJSONString = _sessao.Consultar(Key);
                return JsonConvert.DeserializeObject<ClienteModel>(clienteJSONString);
            }
            else
            {
                return null;
            }
        }
        //Remove a sessão e desloga o Cliente
        public void Logout()
        {
            _sessao.RemoverTodos();
        }
    }
}

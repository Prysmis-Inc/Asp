using HayumiWeb.Models;

namespace HayumiWeb.Repositorio
{
    public interface IClienteRepositorio
    {
        ClienteModel Login(string Email, string Senha);
        // Outros métodos de repositório podem ser adicionados aqui, como Cadastrar Cliente

        void Cadastrar(ClienteModel cliente);

        void Alterar(ClienteModel cliente);

        ClienteModel BuscarClientePorId(int clienteId);

        public List<ClienteModel> BuscarTodosClientes();
        public void InserirCategoria(CategoriaModel categoria);
        public void InserirPeca(PecaModel peca);

    }
}

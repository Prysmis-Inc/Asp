using HayumiWeb.Models;

namespace HayumiWeb.Repositories;

public class ClienteRepository : IClienteRepository
{
    // TODO: Trocar pelo banco de dados
    private static readonly Dictionary<int, ClienteModel> _clienteRepository = new Dictionary<int, ClienteModel>();

    public void Atualizar(ClienteModel clienteModel)
    {
        var cliente = ConsultarPorId(clienteModel.ClienteID);

        if (cliente != null)
        {
            _clienteRepository[clienteModel.ClienteID] = clienteModel;
        }
    }

    public void Cadastrar(ClienteModel clienteModel)
    {
        if (_clienteRepository.Count == 0)
        {
            clienteModel.ClienteID++;
        }
        else
        {
            var ultimoCliente = _clienteRepository.Last().Value;

            clienteModel.ClienteID = ultimoCliente.ClienteID + 1;
        }

        _clienteRepository.Add(clienteModel.ClienteID, clienteModel);
    }

    public ClienteModel? ConsultarPorId(int id)
    {
        if (_clienteRepository.TryGetValue(id, out var clienteModel))
        {
            return clienteModel;
        }

        return null;
    }
}

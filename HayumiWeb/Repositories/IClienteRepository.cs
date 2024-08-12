using HayumiWeb.Models;

namespace HayumiWeb.Repositories;

public interface IClienteRepository
{
    void Cadastrar(ClienteModel clienteModel);
    ClienteModel? ConsultarPorId(int id);
    void Atualizar(ClienteModel clienteModel);
}

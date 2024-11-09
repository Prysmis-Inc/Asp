using HayumiWeb.Models;

namespace HayumiWeb.Repositorio
{
    public interface IPecaRepositorio
    {
        List<PecaModel> BuscarPecaPorCategoria(int categoriaId);

        PecaModel? BuscarPecaPorId(int pecaId);
    }
}

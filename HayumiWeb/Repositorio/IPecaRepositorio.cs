using HayumiWeb.Models;

namespace HayumiWeb.Repositorio
{
    public interface IPecaRepositorio
    {
        List<PecaModel> BuscarPecaPorCategoria(int categoriaId);
    }
}

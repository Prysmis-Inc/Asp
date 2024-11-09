using HayumiWeb.Models;

namespace HayumiWeb.Repositorio
{
    public interface ICategoriaRepositorio
    {
        List<CategoriaModel> BuscarCategorias();
    }
}

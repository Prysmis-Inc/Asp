using HayumiWeb.Models;

namespace HayumiWeb.Repositorio
{
    public interface IPecaRepositorio
    {
        List<PecaModel> BuscarPecaPorCategoria(int categoriaId);

        PecaModel? BuscarPecaPorId(int pecaId);
        List<PecaModel> BuscarPecaPorNome(string pesquisa);
        List<PecaModel> BuscarTodasAsPecas();
        public List<PecaModel> BuscarPecaCategorias();
    }
}

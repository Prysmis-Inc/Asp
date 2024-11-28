using HayumiWeb.Models;

namespace HayumiWeb.Repositorio
{
    public interface ICarrinhoRepositorio
    {
        // Adiciona um item ao carrinho de compras
        void AdicionarItem(int clienteId, int pecaId, int quantidade);

        // Lista todos os itens do carrinho de compras para um cliente
        List<CarrinhoCompra> ListarCarrinho(int clienteId);

        // Remove um item do carrinho de compras
        void RemoverItem(int clienteId, int pecaId);

        // Atualiza a quantidade de um item no carrinho
        void AtualizarQuantidade(int clienteId, int pecaId, int quantidade);
        public CarrinhoCompra? ObterCarrinhoPorId(int clienteId);
    }
}

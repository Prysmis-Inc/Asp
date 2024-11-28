namespace HayumiWeb.Repositorio
{
    public interface IPedidoRepositorio
    {
        // Método que finaliza o pedido e retorna o ID do pedido
        public int InserirPedido(int carrinhoId);
        public int ConfirmarPedido(int pedidoId);
    }
}

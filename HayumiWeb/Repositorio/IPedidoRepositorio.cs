namespace HayumiWeb.Repositorio
{
    public interface IPedidoRepositorio
    {
        // Método que finaliza o pedido e retorna o ID do pedido
        int FinalizarPedido(int clienteId);
    }
}

using HayumiWeb.Models;

namespace HayumiWeb.Repositorio
{
    public interface IPedidoRepositorio
    {
        // Método que finaliza o pedido e retorna o ID do pedido
        public int InserirPedido(int clienteId);
        public int ConfirmarPedido(int pedidoId);
        public PedidoModel BuscaPedidoPorId(int pedidoId);
    }
}

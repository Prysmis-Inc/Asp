namespace HayumiWeb.Models
{
    public class ItemPedido
    {
        public int ItemPedidoId { get; set; }
        public int PedidoId { get; set; }
        public int PecaId { get; set; }
        public int QtdPeca { get; set; }
        public decimal ValorUnitario { get; set; }
        public decimal ValorTotal { get; set; }
    }
}

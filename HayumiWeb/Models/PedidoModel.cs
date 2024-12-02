namespace HayumiWeb.Models;

public class PedidoModel
{
    public int PedidoId { get; set; }
    public DateTime DataPedido { get; set; }
    public int ClienteId { get; set; }
    public string StatusPedido { get; set; }
    public List<ItemPedido> Itens { get; set; } = [];
    public ClienteModel Cliente { get; set; }
    public PagamentoModel Pagamento { get; set; }
    public ItemPedido ItemPedido { get; set; }
    public PecaModel Peca { get; set; }
}

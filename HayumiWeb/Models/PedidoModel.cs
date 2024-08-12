namespace HayumiWeb.Models;

public class PedidoModel
{
    public int PedidoID { get; set; }
    public DateTime DataPedido { get; set; }
    public string InformacaoPedido { get; set; }
    public decimal ValorTotal { get; set; }
    public int ClienteID { get; set; }
    public int NF { get; set; }
}

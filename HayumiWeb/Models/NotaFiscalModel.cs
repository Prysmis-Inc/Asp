namespace HayumiWeb.Models;

public class NotaFiscalModel
{
    public int NF { get; set; }
    public DateOnly DataEmissao { get; set; }
    public decimal ValorTotal { get; set; }
    public string NomeEmpresa { get; set; }
    public string Produtos { get; set; }
    public int PedidoID { get; set; }
    public DateTime DataPedido { get; set; }
    public double ValorUnitario { get; set; }
    public int ClienteID { get; set; }
}
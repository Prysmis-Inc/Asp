namespace HayumiWeb.Models
{
    public class PagamentoViewModel
    {
        public PedidoModel Pedido { get; set; }

        public PagamentoModel Pagamento { get; set; }
        public string FormaPagamento { get; set; } = string.Empty;
        public int PedidoId { get; set; }
        public string? NomeTitular { get; set; }
        public string? BandeiraCartao { get; set; }
        public long? NumeroCartao { get; set; }
        public int? CVV { get; set; }
        public string? DataValidade { get; set; }
        public string? ChavePix { get; set; }
        public string? CodigoBoleto { get; set; }
    }
}

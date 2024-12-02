using System.ComponentModel.DataAnnotations;

namespace HayumiWeb.Models
{
    public class PagamentoModel
    {
        public int PagamentoId { get; set; }
        public int PedidoId { get; set; }
        public decimal ValorPago { get; set; }
        public DateTime DataPagamento { get; set; }
        public string StatusPagamento { get; set; }  // Aprovado, Pendente, Cancelado
        public string TipoPagamento { get; set; }    // Cartão, Boleto, etc.

        // Dados do Cartão (caso o pagamento seja com cartão)
        public string? NomeTitular { get; set; }
        public string? BandeiraCartao { get; set; }
        public decimal? NumeroCartao { get; set; }
        public int? CVV { get; set; }
        public string? DataValidade { get; set; }
    }
}

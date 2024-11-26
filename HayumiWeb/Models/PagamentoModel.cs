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
        public string NomeCartao { get; set; }
        public string BandeiraCartao { get; set; }
        public string NumeroCartao { get; set; }
        public string CVV { get; set; }
    }
}

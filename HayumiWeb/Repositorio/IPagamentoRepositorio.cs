using HayumiWeb.Models;

namespace HayumiWeb.Repositorio
{
    public interface IPagamentoRepositorio
    {
        void CriarPagamento(int pedidoId, decimal valorPago, string tipoPagamento, string nomeCartao = null, string bandeiraCartao = null, string numeroCartao = null, string cvv = null);
        PagamentoModel ObterPagamento(int pedidoId);
    }
}

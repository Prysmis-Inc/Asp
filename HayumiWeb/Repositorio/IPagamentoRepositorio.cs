using HayumiWeb.Models;

namespace HayumiWeb.Repositorio
{
    public interface IPagamentoRepositorio
    {
        public void Pagar(PagamentoModel pagamento);
    }
}

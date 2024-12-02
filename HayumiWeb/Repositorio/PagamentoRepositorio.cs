using HayumiWeb.Models;
using MySql.Data.MySqlClient;
using System.Data;

namespace HayumiWeb.Repositorio
{
    public class PagamentoRepositorio : IPagamentoRepositorio
    {
        private readonly string? _conexaoMySQL;

        // Construtor que obtém a string de conexão do arquivo de configuração
        public PagamentoRepositorio(IConfiguration conf) => _conexaoMySQL = conf.GetConnectionString("ConexaoMySQL");

        public void Pagar(PagamentoModel pagamento)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();

                using (var cmd = new MySqlCommand("spInsertPagamento", conexao))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parâmetros para evitar SQL Injection
                    cmd.Parameters.AddWithValue("@pPedidoId", pagamento.PedidoId);
                    cmd.Parameters.AddWithValue("@pValorPago", pagamento.ValorPago);
                    cmd.Parameters.AddWithValue("@pDataPagamento", pagamento.DataPagamento);
                    cmd.Parameters.AddWithValue("@pTipoPagamento", pagamento.TipoPagamento);
                    cmd.Parameters.AddWithValue("@pNomeTitular", pagamento.NomeTitular ?? (object)DBNull.Value);  // Caso NomeTitular seja null
                    cmd.Parameters.AddWithValue("@pBandeiraCartao", pagamento.BandeiraCartao ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@pNumeroCartao", pagamento.NumeroCartao ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@pCVV", pagamento.CVV ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@pDataValidade", pagamento.DataValidade ?? (object)DBNull.Value);

                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}

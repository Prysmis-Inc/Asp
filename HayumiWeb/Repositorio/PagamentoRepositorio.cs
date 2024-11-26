using HayumiWeb.Models;
using MySql.Data.MySqlClient;

namespace HayumiWeb.Repositorio
{
    public class PagamentoRepositorio : IPagamentoRepositorio
    {
        private readonly string _conexaoMySQL;

        public PagamentoRepositorio(IConfiguration conf)
        {
            _conexaoMySQL = conf.GetConnectionString("ConexaoMySQL");
        }

        // Cria um pagamento no banco de dados
        public void CriarPagamento(int pedidoId, decimal valorPago, string tipoPagamento, string nomeCartao = null, string bandeiraCartao = null, string numeroCartao = null, string cvv = null)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();
                var cmd = new MySqlCommand("INSERT INTO tbPagamento (PedidoId, ValorPago, DataPagamento, StatusPagamento, TipoPagamento, NomeCartao, BandeiraCartao, NumeroCartao, CVV) " +
                                           "VALUES (@PedidoId, @ValorPago, @DataPagamento, @StatusPagamento, @TipoPagamento, @NomeCartao, @BandeiraCartao, @NumeroCartao, @CVV)", conexao);
                cmd.Parameters.AddWithValue("@PedidoId", pedidoId);
                cmd.Parameters.AddWithValue("@ValorPago", valorPago);
                cmd.Parameters.AddWithValue("@DataPagamento", DateTime.Now);
                cmd.Parameters.AddWithValue("@StatusPagamento", "Pendente");  // Status inicial "Pendente"
                cmd.Parameters.AddWithValue("@TipoPagamento", tipoPagamento);
                cmd.Parameters.AddWithValue("@NomeCartao", nomeCartao ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@BandeiraCartao", bandeiraCartao ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@NumeroCartao", numeroCartao ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@CVV", cvv ?? (object)DBNull.Value);

                cmd.ExecuteNonQuery();
            }
        }

        // Obtém o pagamento relacionado a um pedido
        public PagamentoModel ObterPagamento(int pedidoId)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();

                var cmd = new MySqlCommand("SELECT * FROM tbPagamento WHERE PedidoId = @PedidoId", conexao);
                cmd.Parameters.AddWithValue("@PedidoId", pedidoId);

                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new PagamentoModel
                        {
                            PagamentoId = reader.GetInt32(reader.GetOrdinal("PagamentoId")),
                            PedidoId = reader.GetInt32(reader.GetOrdinal("PedidoId")),
                            ValorPago = reader.GetDecimal(reader.GetOrdinal("ValorPago")),
                            DataPagamento = reader.GetDateTime(reader.GetOrdinal("DataPagamento")),
                            StatusPagamento = reader["StatusPagamento"]?.ToString(), // Garantir que não seja null
                            TipoPagamento = reader["TipoPagamento"]?.ToString(), // Garantir que não seja null
                            NomeCartao = reader["NomeCartao"]?.ToString(), // Pode ser nulo
                            BandeiraCartao = reader["BandeiraCartao"]?.ToString(), // Pode ser nulo
                            NumeroCartao = reader["NumeroCartao"]?.ToString(), // Pode ser nulo
                            CVV = reader["CVV"]?.ToString() // Pode ser nulo
                        };
                    }
                }
            }

            return null; // Retorna null caso não encontre o pagamento
        }
    }
}

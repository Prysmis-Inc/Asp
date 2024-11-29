using HayumiWeb.Models;
using MySql.Data.MySqlClient;
using System;
using System.Data;

namespace HayumiWeb.Repositorio
{
    public class PedidoRepositorio : IPedidoRepositorio
    {
        private readonly string? _conexaoMySQL;

        // Construtor que obtém a string de conexão do arquivo de configuração
        public PedidoRepositorio(IConfiguration conf) => _conexaoMySQL = conf.GetConnectionString("ConexaoMySQL");

        public int InserirPedido(int clienteId)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();

                using (var cmd = new MySqlCommand("spInsertPedido", conexao))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parâmetros da stored procedure
                    cmd.Parameters.AddWithValue("vClienteId", clienteId);
                    cmd.Parameters.AddWithValue("vStatusPedido", "pendente"); // Status fixo como 'pendente'

                    // Adiciona um parâmetro de saída para obter o ID do pedido inserido
                    MySqlParameter outputParam = new MySqlParameter("@vPedidoId", MySqlDbType.Int32)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outputParam);

                    // Executa a stored procedure
                    cmd.ExecuteNonQuery();

                    // Retorna o ID do pedido inserido
                    return Convert.ToInt32(outputParam.Value);
                }
            }
        }


        public int ConfirmarPedido(int pedidoId)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();

                using (var cmd = new MySqlCommand("spConfirmarPedido", conexao))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parâmetro de entrada para o PedidoId
                    cmd.Parameters.AddWithValue("vPedidoId", pedidoId);

                    // Executa a stored procedure
                    using (MySqlDataReader reader = cmd.ExecuteReader())
                    {
                        // Verifica se o pedido foi encontrado e confirmado
                        if (reader.Read())
                        {
                            // Retorna o PedidoId se a confirmação foi bem-sucedida
                            return Convert.ToInt32(reader["PedidoId"]);
                        }
                    }

                    // Se não foi possível confirmar o pedido, retorna -1
                    return -1;
                }
            }
        }

        public PedidoModel BuscaPedidoPorId(int pedidoId)
        {

        }
    }
}

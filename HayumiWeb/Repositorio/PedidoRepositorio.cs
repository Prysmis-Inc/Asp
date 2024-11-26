using MySql.Data.MySqlClient;
using System;

namespace HayumiWeb.Repositorio
{
    public class PedidoRepositorio : IPedidoRepositorio
    {
        private readonly string? _conexaoMySQL;

        // Construtor que obtém a string de conexão do arquivo de configuração
        public PedidoRepositorio(IConfiguration conf) => _conexaoMySQL = conf.GetConnectionString("ConexaoMySQL");

        // Método que finaliza o pedido e retorna o ID do pedido recém-criado
        public int FinalizarPedido(int clienteId)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();
                var transaction = conexao.BeginTransaction();

                try
                {
                    // 1. Criar o Pedido
                    var cmdCriarPedido = new MySqlCommand("INSERT INTO tbPedido (ClienteId, DataPedido) VALUES (@ClienteId, @DataPedido); SELECT LAST_INSERT_ID();", conexao, transaction);
                    cmdCriarPedido.Parameters.AddWithValue("@ClienteId", clienteId);
                    cmdCriarPedido.Parameters.AddWithValue("@DataPedido", DateTime.Now);
                    int pedidoId = Convert.ToInt32(cmdCriarPedido.ExecuteScalar());  // Pega o ID do pedido recém-criado

                    // 2. Obter os Itens do Carrinho
                    var cmdCarrinho = new MySqlCommand("SELECT CarrinhoId, PecaId, QtdPeca FROM tbCarrinhoCompra WHERE ClienteId = @ClienteId", conexao, transaction);
                    cmdCarrinho.Parameters.AddWithValue("@ClienteId", clienteId);

                    using (var reader = cmdCarrinho.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            int pecaId = Convert.ToInt32(reader["PecaId"]);
                            int qtdPeca = Convert.ToInt32(reader["QtdPeca"]);

                            // 3. Adicionar os Itens ao Pedido (tbItemPedido)
                            var cmdAdicionarItem = new MySqlCommand("INSERT INTO tbItemPedido (PedidoId, PecaId, QtdPeca, ValorUnitario, ValorTotal) " +
                                                                    "SELECT @PedidoId, @PecaId, @QtdPeca, ValorPeca, ValorPeca * @QtdPeca " +
                                                                    "FROM tbPeca WHERE PecaId = @PecaId", conexao, transaction);
                            cmdAdicionarItem.Parameters.AddWithValue("@PedidoId", pedidoId);
                            cmdAdicionarItem.Parameters.AddWithValue("@PecaId", pecaId);
                            cmdAdicionarItem.Parameters.AddWithValue("@QtdPeca", qtdPeca);
                            cmdAdicionarItem.ExecuteNonQuery();

                            // 4. Atualizar o Estoque da Peça
                            var cmdAtualizarEstoque = new MySqlCommand("UPDATE tbPeca SET qtd_estoque = qtd_estoque - @QtdPeca WHERE PecaId = @PecaId", conexao, transaction);
                            cmdAtualizarEstoque.Parameters.AddWithValue("@QtdPeca", qtdPeca);
                            cmdAtualizarEstoque.Parameters.AddWithValue("@PecaId", pecaId);
                            cmdAtualizarEstoque.ExecuteNonQuery();
                        }
                    }

                    // 5. Remover os Itens do Carrinho
                    var cmdRemoverCarrinho = new MySqlCommand("DELETE FROM tbCarrinhoCompra WHERE ClienteId = @ClienteId", conexao, transaction);
                    cmdRemoverCarrinho.Parameters.AddWithValue("@ClienteId", clienteId);
                    cmdRemoverCarrinho.ExecuteNonQuery();

                    // 6. Commit da transação
                    transaction.Commit();

                    // Retorna o ID do pedido gerado
                    return pedidoId;
                }
                catch (Exception ex)
                {
                    // Em caso de erro, desfaz todas as operações
                    transaction.Rollback();
                    throw new Exception("Erro ao finalizar o pedido: " + ex.Message);
                }
            }
        }
    }
}

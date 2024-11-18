using HayumiWeb.Models;
using MySql.Data.MySqlClient;

namespace HayumiWeb.Repositorio
{
    public class CarrinhoRepositorio : ICarrinhoRepositorio
    {
        private readonly string? _conexaoMySQL;

        //metodo da conexão com banco de dados
        public CarrinhoRepositorio(IConfiguration conf) => _conexaoMySQL = conf.GetConnectionString("ConexaoMySQL");

        // Adiciona um item no carrinho
        public void AdicionarItem(int clienteId, int pecaId, int quantidade)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();

                // Verifica se a peça já está no carrinho
                var cmdVerificar = new MySqlCommand("SELECT * FROM tbCarrinhoCompra WHERE ClienteId = @ClienteId AND PecaId = @PecaId", conexao);
                cmdVerificar.Parameters.AddWithValue("@ClienteId", clienteId);
                cmdVerificar.Parameters.AddWithValue("@PecaId", pecaId);

                using (var reader = cmdVerificar.ExecuteReader())
                {
                    if (reader.HasRows)  // Item já está no carrinho, apenas atualiza a quantidade
                    {
                        reader.Read(); // Lê a primeira linha do DataReader

                        // Obtém o carrinhoId e a quantidade atual
                        int carrinhoId = Convert.ToInt32(reader["CarrinhoId"]);
                        int qtdAtual = Convert.ToInt32(reader["QtdPeca"]);

                        // Fechar o DataReader antes de executar o próximo comando
                        reader.Close();  // Fechar explicitamente o reader

                        // Agora podemos executar o comando de atualização sem problemas
                        var cmdAtualizar = new MySqlCommand("UPDATE tbCarrinhoCompra SET QtdPeca = @QtdPeca WHERE CarrinhoId = @CarrinhoId", conexao);
                        cmdAtualizar.Parameters.AddWithValue("@QtdPeca", qtdAtual + quantidade);  // Atualiza a quantidade
                        cmdAtualizar.Parameters.AddWithValue("@CarrinhoId", carrinhoId);
                        cmdAtualizar.ExecuteNonQuery();
                    }
                    else  // Adiciona novo item ao carrinho
                    {
                        // Fechar o DataReader antes de executar o próximo comando
                        reader.Close();  // Fechar explicitamente o reader

                        var cmdAdicionar = new MySqlCommand("INSERT INTO tbCarrinhoCompra (ClienteId, PecaId, QtdPeca) VALUES (@ClienteId, @PecaId, @QtdPeca)", conexao);
                        cmdAdicionar.Parameters.AddWithValue("@ClienteId", clienteId);
                        cmdAdicionar.Parameters.AddWithValue("@PecaId", pecaId);
                        cmdAdicionar.Parameters.AddWithValue("@QtdPeca", quantidade);
                        cmdAdicionar.ExecuteNonQuery();
                    }
                }
            }
        }

        // Lista todos os itens do carrinho de compras para um cliente
        public List<CarrinhoCompra> ListarCarrinho(int clienteId)
        {
            var itensCarrinho = new List<CarrinhoCompra>();

            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();
                var cmd = new MySqlCommand("SELECT * FROM tbCarrinhoCompra WHERE ClienteId = @ClienteId", conexao);
                cmd.Parameters.AddWithValue("@ClienteId", clienteId);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var item = new CarrinhoCompra
                        {
                            CarrinhoId = Convert.ToInt32(reader["CarrinhoId"]),
                            ClienteId = Convert.ToInt32(reader["ClienteId"]),
                            PecaId = Convert.ToInt32(reader["PecaId"]),
                            QtdPeca = Convert.ToInt32(reader["QtdPeca"]),
                        };
                        itensCarrinho.Add(item);
                    }
                }
            }

            return itensCarrinho;
        }

        // Remove um item do carrinho de compras
        public void RemoverItem(int clienteId, int pecaId)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();
                var cmd = new MySqlCommand("DELETE FROM tbCarrinhoCompra WHERE ClienteId = @ClienteId AND PecaId = @PecaId", conexao);
                cmd.Parameters.AddWithValue("@ClienteId", clienteId);
                cmd.Parameters.AddWithValue("@PecaId", pecaId);
                cmd.ExecuteNonQuery();
            }
        }

        // Atualiza a quantidade de um item no carrinho
        public void AtualizarQuantidade(int clienteId, int pecaId, int quantidade)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();
                var cmd = new MySqlCommand("UPDATE tbCarrinhoCompra SET QtdPeca = @QtdPeca WHERE ClienteId = @ClienteId AND PecaId = @PecaId", conexao);
                cmd.Parameters.AddWithValue("@QtdPeca", quantidade);
                cmd.Parameters.AddWithValue("@ClienteId", clienteId);
                cmd.Parameters.AddWithValue("@PecaId", pecaId);
                cmd.ExecuteNonQuery();
            }
        }
    }
}

using HayumiWeb.Models;
using MySql.Data.MySqlClient;
using System.Data;

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
                var cmd = new MySqlCommand("""
                    SELECT *
                    FROM tbCarrinhoCompra
                    INNER JOIN tbPeca on tbCarrinhoCompra.PecaId = tbPeca.PecaId
                    WHERE ClienteId = @ClienteId
                    """, conexao);
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
                            Peca = new PecaModel
                            {
                                NomePeca = Convert.ToString(reader["NomePeca"]),
                                ImgPeca = Convert.ToString(reader["img_peca"]),
                                ValorPeca = Convert.ToDouble(reader["ValorPeca"]),
                                QtdEstoque = Convert.ToInt32(reader["qtd_estoque"]),
                            }
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

        public CarrinhoCompra? ObterCarrinhoPorId(int clienteId)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                // Abre a conexão com o banco de dados
                conexao.Open();

                // Comando SQL para buscar a peça pelo ID
                MySqlCommand cmd = new MySqlCommand("select * from tbCarrinhoCompra where ClienteId = @clientId;", conexao);

                cmd.Parameters.Add("@clientId", MySqlDbType.Int32).Value = clienteId;

                // Adiciona o parâmetro para o ID da peça

                // Executa a consulta e obtém o leitor de dados
                using (MySqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    if (dr.Read()) // Se houver carro com o ID especificado
                    {
                        CarrinhoCompra carro = new CarrinhoCompra();
                        carro.CarrinhoId= Convert.ToInt32(dr["CarrinhoId"]);
                        carro.ClienteId = Convert.ToInt32(dr["ClienteId"]);
                        carro.PecaId= Convert.ToInt32(dr["PecaId"]);
                        carro.QtdPeca = Convert.ToInt32(dr["QtdPeca"]);
                        return carro;
                    }
                }
                return null;
            }
        }

        public List<CarrinhoCompra> MostrarCarros() 
        {
            //usando a variavel conexao 
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                //abre a conexão com o banco de dados
                conexao.Open();

                // variavel cmd que recebe o select do banco de dados
                MySqlCommand cmd = new MySqlCommand("select CarrinhoId, QtdPeca, tbCarrinhoCompra.ClienteId, tbCliente.NomeCli, tbCarrinhoCompra.PecaId, tbPeca.NomePeca from tbCarrinhoCompra" +
                                                    " inner join tbCliente on tbCarrinhoCompra.ClienteId = tbCliente.ClienteId " +
                                                    "inner join tbPeca on tbCarrinhoCompra.PecaId = tbPeca.PecaId;", conexao);

                //Le os dados que foi pego das categorias
                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                //guarda os dados que foi pego do categoria do banco de dados
                MySqlDataReader dr;

                //instanciando a model categoria
                List<CarrinhoCompra> carrinhos = new List<CarrinhoCompra>();

                //executando os comandos do mysql e passsando paa a variavel dr
                dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                //verifica todos os dados que foram pego do banco e pega a categoria
                while (dr.Read())
                {
                    CarrinhoCompra carro = new CarrinhoCompra();
                    carro.CarrinhoId = Convert.ToInt32(dr["CarrinhoId"]);
                    carro.QtdPeca = Convert.ToInt32(dr["QtdPeca"])!;
                    carro.ClienteId = Convert.ToInt32(dr["ClienteId"]);
                    carrinhos.Add(carro);
                    PecaModel peca = new PecaModel();
                    {
                        peca.NomePeca = Convert.ToString(dr["NomePeca"]);
                    }
                    ClienteModel cliente = new ClienteModel();
                    {
                        cliente.NomeCli = Convert.ToString(dr["NomeCli"]);
                    }
                    carro.Peca = peca;
                    carro.Cliente = cliente;
                    carrinhos.Add(carro);
                }

                return carrinhos;
            }
        }
    }
}
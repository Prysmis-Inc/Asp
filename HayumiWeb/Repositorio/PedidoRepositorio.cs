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
            //usando a variavel conexao 
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                //abre a conexão com o banco de dados
                conexao.Open();

                // variavel cmd que receb o select do banco de dados buscando email e senha
                MySqlCommand cmd = new MySqlCommand("select * from tbpedido " +
                                                    "inner join tbitempedido on tbpedido.pedidoid = tbitempedido.pedidoid " +
                                                    "inner join tbPeca on tbitempedido.PecaId = tbpeca.pecaid " +
                                                    "where tbpedido.pedidoid = @pedidoid;", conexao);

                //os paramentros do email e da senha 
                cmd.Parameters.Add("@pedidoId", MySqlDbType.Int32).Value = pedidoId;


                PedidoModel pedido = new PedidoModel();
                List<ItemPedido> itens = new List<ItemPedido>();

                // Executa a consulta e obtém o leitor de dados
                using (MySqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (dr.Read()) // Se houver uma pedido com o ID especificado
                    {
                        pedido.PedidoId = Convert.ToInt32(dr["PedidoId"]);
                        pedido.DataPedido = Convert.ToDateTime(dr["datapedido"])!;
                        pedido.ClienteId = Convert.ToInt32(dr["ClienteId"])!;
                        pedido.StatusPedido = Convert.ToString(dr["StatusPedido"])!;
                        PecaModel peca = new PecaModel();
                        {
                            peca.PecaId = Convert.ToInt32(dr["PecaId"]);
                            peca.ValorPeca = Convert.ToDouble(dr["ValorPeca"]);
                            peca.NomePeca = Convert.ToString(dr["NomePeca"]);
                            peca.ImgPeca = Convert.ToString(dr["img_peca"]);
                            peca.QtdEstoque = Convert.ToInt32(dr["qtd_estoque"]);
                            peca.Descricao = Convert.ToString(dr["descricao"]);
                        }
                        ItemPedido item = new ItemPedido();
                        {
                            item.ItemPedidoId = Convert.ToInt32(dr["ItemPedidoId"]);
                            item.PecaId = Convert.ToInt32(dr["PecaId"]);
                            item.PedidoId = Convert.ToInt32(dr["PedidoId"]);
                            item.QtdPeca = Convert.ToInt32(dr["QtdPeca"]);
                            item.ValorUnitario = Convert.ToInt32(dr["ValorUnitario"]);
                            item.ValorTotal = Convert.ToDecimal(dr["ValorTotal"]);
                            item.Peca = peca;
                        }

                        itens.Add(item);
                        pedido.Itens = itens;
                    }
                }

                return pedido; // Retorna o pedido
            }
        }

        public List<PedidoModel> BuscaPedidoPorCliente(int clienteId)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();

                MySqlCommand cmd = new MySqlCommand("SELECT * FROM tbpedido WHERE ClienteId = @clienteId ORDER BY PedidoId DESC", conexao);
                cmd.Parameters.AddWithValue("@clienteId", clienteId);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                //guarda os dados que foi pego do categoria do banco de dados
                MySqlDataReader dr;

                //instanciando a model peça
                List<PedidoModel> listaPedidos = new List<PedidoModel>();

                //executando os comandos do mysql e passsando paa a variavel dr
                dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                //verifica todos os dados que foram pego do banco e pega a categoria
                while (dr.Read())
                {
                    PedidoModel pedido = new PedidoModel();
                    pedido.PedidoId = Convert.ToInt32(dr["PedidoId"]);
                    pedido.DataPedido = Convert.ToDateTime(dr["datapedido"]);
                    pedido.ClienteId = Convert.ToInt32(dr["ClienteId"]);
                    pedido.StatusPedido = Convert.ToString(dr["StatusPedido"]);
                    listaPedidos.Add(pedido);
                }

                return listaPedidos;
            }
        }

        public List<PedidoModel> MostrarPedidos()
        {
            //usando a variavel conexao 
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                //abre a conexão com o banco de dados
                conexao.Open();

                // variavel cmd que receb o select do banco de dados buscando email e senha
                MySqlCommand cmd = new MySqlCommand("select tbPedido.PedidoId, datapedido, tbPedido.ClienteId, StatusPedido, ItemPedidoId, QtdPeca, ValorUnitario, ValorTotal," +
                                                    " tbPeca.NomePeca, tbCliente.NomeCli, PagamentoId, ValorPago, DataPagamento, StatusPagamento, TipoPagamento, NomeTitular, BandeiraCartao, NumeroCartao, CVV, DataValidade from tbPedido" +
                                                    " inner join tbitempedido on tbPedido.PedidoId = tbitempedido.PedidoId" +
                                                    " inner join tbpeca on tbitempedido.pecaid = tbpeca.pecaid" +
                                                    " inner join tbCliente on tbpedido.clienteid = tbcliente.clienteid" +
                                                    " inner join tbPagamento on tbPedido.PedidoId = tbPagamento.PedidoId;", conexao);

                //os paramentros do email e da senha

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                //guarda os dados que foi pego do categoria do banco de dados
                MySqlDataReader dr;

                //instanciando a model peça
                List<PedidoModel> listPedido = new List<PedidoModel>();

                //executando os comandos do mysql e passsando paa a variavel dr
                dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                //verifica todos os dados que foram pego do banco e pega a categoria
                while (dr.Read())
                {
                    PedidoModel pedido = new PedidoModel();
                    pedido.PedidoId = Convert.ToInt32(dr["PedidoId"]);
                    pedido.DataPedido = Convert.ToDateTime(dr["datapedido"]);
                    pedido.ClienteId = Convert.ToInt32(dr["ClienteId"]);
                    pedido.StatusPedido = Convert.ToString(dr["StatusPedido"]);
                    ItemPedido item = new ItemPedido();
                    {
                        item.ItemPedidoId = Convert.ToInt32(dr["ItemPedidoId"]);
                        item.QtdPeca = Convert.ToInt32(dr["QtdPeca"]);
                        item.ValorUnitario = Convert.ToInt32(dr["ValorUnitario"]);
                        item.ValorTotal = Convert.ToDecimal(dr["ValorTotal"]);
                    }
                    ClienteModel cliente = new ClienteModel();
                    {
                        cliente.NomeCli = Convert.ToString(dr["NomeCli"]);
                    }
                    PecaModel peca = new PecaModel();
                    {
                        peca.NomePeca = Convert.ToString(dr["NomePeca"]);
                    }
                    pedido.Peca = peca;
                    pedido.ItemPedido = item;
                    pedido.Cliente = cliente;
                    listPedido.Add(pedido);
                }
                return listPedido;
            }
        }
    } 
}

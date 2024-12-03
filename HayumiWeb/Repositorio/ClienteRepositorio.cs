using System.Data;
using MySql.Data.MySqlClient;
using HayumiWeb.Models;
using MySqlX.XDevAPI;
namespace HayumiWeb.Repositorio;

public class ClienteRepositorio : IClienteRepositorio
{
    // essa vai ser a variável da conexão
    private readonly string? _conexaoMySQL;

    //metodo da conexão com banco de dados
    public ClienteRepositorio(IConfiguration conf) => _conexaoMySQL = conf.GetConnectionString("ConexaoMySQL");

    public ClienteModel Login(string Email, string Senha)
    {
        //usando a variavel conexao 
        using (var conexao = new MySqlConnection(_conexaoMySQL))
        {
            //abre a conexão com o banco de dados
            conexao.Open();

            // variavel cmd que receb o select do banco de dados buscando email e senha
            MySqlCommand cmd = new MySqlCommand("select * from tbCliente where Email = @Email and SenhaUsu = @Senha", conexao);

            //os paramentros do email e da senha 
            cmd.Parameters.Add("@Email", MySqlDbType.VarChar).Value = Email;
            cmd.Parameters.Add("@Senha", MySqlDbType.VarChar).Value = Senha;


            //instanciando a model cliente
            ClienteModel cliente = new ClienteModel();


            //verifica todos os dados que foram pego do banco e pega o email e senha
            using (MySqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection))
            {
                while (dr.Read())
                {
                    cliente.Email = Convert.ToString(dr["Email"]);
                    cliente.SenhaUsu = Convert.ToString(dr["SenhaUsu"]);
                    cliente.ClienteId = Convert.ToInt32(dr["ClienteId"]);
                    cliente.ClienteStatus = Convert.ToBoolean(dr["Cliente_Status"]);
                }
            }
            return cliente;
        }
    }

    public void Cadastrar(ClienteModel cliente)
    {
        using (var conexao = new MySqlConnection(_conexaoMySQL))
        {
            conexao.Open();

            using (var cmd = new MySqlCommand("spInsertCliente", conexao))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("vNomeCli", cliente.NomeCli);
                cmd.Parameters.AddWithValue("vCPF", cliente.CPF);
                cmd.Parameters.AddWithValue("vEmail", cliente.Email);
                cmd.Parameters.AddWithValue("vSenhaUsu", cliente.SenhaUsu);
                cmd.Parameters.AddWithValue("vDataNasc", cliente.DataNasc);
                cmd.Parameters.AddWithValue("vTelefone", cliente.Telefone);
                cmd.Parameters.AddWithValue("vNumEnd", cliente.NumEnd);
                cmd.Parameters.AddWithValue("vCompEnd", cliente.CompEnd);
                cmd.Parameters.AddWithValue("vCEP", cliente.CEP);
                cmd.Parameters.AddWithValue("vLogradouro", cliente.Logradouro);
                cmd.Parameters.AddWithValue("vClienteStatus", cliente.ClienteStatus);
                cmd.Parameters.AddWithValue("vBairro", cliente.Bairro.Bairro);
                cmd.Parameters.AddWithValue("vCidade", cliente.Cidade.Cidade);
                cmd.Parameters.AddWithValue("vUF", cliente.Estado.UF);

                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string mensagem = reader["Mensagem"].ToString();
                        Console.WriteLine(mensagem);
                    }
                }
            }
        }
    }


    public void Alterar(ClienteModel cliente)
    {
        using (var conexao = new MySqlConnection(_conexaoMySQL))
        {
            // Abrindo a conexão com o banco de dados
            conexao.Open();

            // Comando para chamar a stored procedure spAtualizaCliente
            using (var cmd = new MySqlCommand("spAtualizaCliente", conexao))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                // Adicionando os parâmetros necessários para a procedure
                cmd.Parameters.AddWithValue("vEmail", cliente.Email);  // Passando o Email
                cmd.Parameters.AddWithValue("vSenhaUsu", cliente.SenhaUsu);
                cmd.Parameters.AddWithValue("vTelefone", cliente.Telefone);
                cmd.Parameters.AddWithValue("vNumEnd", cliente.NumEnd);
                cmd.Parameters.AddWithValue("vCompEnd", cliente.CompEnd);
                cmd.Parameters.AddWithValue("vLogradouro", cliente.Logradouro);  // Corrigido: Logradouro
                cmd.Parameters.AddWithValue("vCEP", cliente.CEP);
                cmd.Parameters.AddWithValue("vDataNasc", cliente.DataNasc);  // Corrigido: vDataNasc está na procedure, mas não foi listado antes

                // Executando a stored procedure
                cmd.ExecuteNonQuery();
            }
        }
    }

    public ClienteModel? BuscarClientePorId(int pecaId)
    {
        using (var conexao = new MySqlConnection(_conexaoMySQL))
        {
            // Abre a conexão com o banco de dados
            conexao.Open();

            // Comando SQL para buscar a peça pelo ID
            MySqlCommand cmd = new MySqlCommand("select * from tbcliente inner join tbEndereco on tbcliente.CEP = tbEndereco.Cep inner join tbBairro on tbEndereco.BairroId = tbBairro.BairroId inner join tbCidade on tbEndereco.CidadeId = tbCidade.CidadeId inner join tbEstado on tbEndereco.UFId = tbEstado.UFId  WHERE tbcliente.ClienteId = @ClienteId;", conexao);

            // Adiciona o parâmetro para o ID da peça
            cmd.Parameters.Add("@ClienteId", MySqlDbType.Int32).Value = pecaId;

            // Executa a consulta e obtém o leitor de dados
            using (MySqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection))
            {
                if (dr.Read()) // Se houver uma peça com o ID especificado
                {
                    ClienteModel cliente = new ClienteModel();
                    cliente.ClienteId = Convert.ToInt32(dr["ClienteId"]);
                    cliente.CPF = Convert.ToDecimal(dr["CPF"])!;
                    cliente.NomeCli = Convert.ToString(dr["NomeCli"])!;
                    cliente.ClienteStatus = Convert.ToBoolean(dr["Cliente_Status"]);
                    cliente.Email = Convert.ToString(dr["Email"])!;
                    cliente.SenhaUsu = Convert.ToString(dr["SenhaUsu"])!;
                    cliente.Telefone = Convert.ToInt64(dr["telefone"])!;
                    cliente.NumEnd = Convert.ToInt32(dr["NumEnd"])!;
                    cliente.CompEnd = Convert.ToString(dr["CompEnd"])!;
                    cliente.CEP = Convert.ToInt32(dr["CEP"])!;
                    cliente.DataNasc = Convert.ToDateTime(dr["DataNasc"]);
                    cliente.Logradouro = Convert.ToString(dr["Logradouro"]);
                    // Preenchendo as propriedades relacionadas aos modelos Bairro, Cidade e Estado
                    cliente.Estado = new EstadoModel
                    {
                        UF = Convert.ToString(dr["UF"])!
                    };

                    cliente.Bairro = new BairroModel
                    {
                        Bairro = Convert.ToString(dr["Bairro"])!
                    };

                    cliente.Cidade = new CidadeModel
                    {
                        Cidade = Convert.ToString(dr["Cidade"])!
                    };

                    return cliente; // Retorna o cliente encontrada
                }
            }
        }

        // Retorna null se nenhum cliente for encontrada com o ID especificado
        return null;
    }

    // PARTE ADM

    public List<ClienteModel> BuscarTodosClientes()
    {
        using (var conexao = new MySqlConnection(_conexaoMySQL))
        {
            //abre a conexão com o banco de dados
            conexao.Open();

            // variavel cmd que recebe o select do banco de dados
            MySqlCommand cmd = new MySqlCommand("select ClienteId, NomeCli, CPF, Email, SenhaUsu, DataNasc, telefone, NumEnd,CompEnd, logradouro, tbCliente.CEP, tbcidade.Cidade, tbEstado.UF, tbBairro.Bairro from tbcliente" +
                                                " inner join tbEndereco on tbcliente.CEP = tbEndereco.Cep " +
                                                "inner join tbBairro on tbEndereco.BairroId = tbBairro.BairroId " +
                                                "inner join tbCidade on tbEndereco.CidadeId = tbCidade.CidadeId " +
                                                "inner join tbEstado on tbEndereco.UFId = tbEstado.UFId;", conexao);

            //Le os dados que foi pego das categorias
            MySqlDataAdapter da = new MySqlDataAdapter(cmd);
            //guarda os dados que foi pego do categoria do banco de dados
            MySqlDataReader dr;

            //instanciando a model categoria
            List<ClienteModel> clientes = new List<ClienteModel>();

            //executando os comandos do mysql e passsando paa a variavel dr
            dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

            //verifica todos os dados que foram pego do banco e pega a categoria
            while (dr.Read())
            {
                ClienteModel cliente = new ClienteModel();
                cliente.ClienteId = Convert.ToInt32(dr["ClienteId"]);
                cliente.NomeCli = Convert.ToString(dr["NomeCli"])!;
                cliente.CPF = Convert.ToDecimal(dr["CPF"]);
                cliente.Email = Convert.ToString(dr["Email"]);
                cliente.SenhaUsu = Convert.ToString(dr["SenhaUsu"]);
                cliente.DataNasc = Convert.ToDateTime(dr["DataNasc"]);
                cliente.Telefone = Convert.ToInt64(dr["telefone"]);
                cliente.NumEnd = Convert.ToInt32(dr["NumEnd"]);
                cliente.CompEnd = Convert.ToString(dr["CompEnd"]);
                cliente.Logradouro = Convert.ToString(dr["logradouro"]);
                cliente.CEP = Convert.ToDecimal(dr["CEP"]);
                cliente.Estado = new EstadoModel
                {
                    UF = Convert.ToString(dr["UF"])!
                };
                cliente.Bairro = new BairroModel
                {
                    Bairro = Convert.ToString(dr["Bairro"])!
                };
                cliente.Cidade = new CidadeModel
                {
                    Cidade = Convert.ToString(dr["Cidade"])!
                };

                clientes.Add(cliente);
            }

            return clientes;
        }
    }

    public void InserirCategoria(CategoriaModel categoria)
    {
        using (var conexao = new MySqlConnection(_conexaoMySQL))
        {
            conexao.Open();

            // Preparar a chamada da stored procedure
            MySqlCommand cmd = new MySqlCommand("spInsertCategoria", conexao);
            cmd.CommandType = CommandType.StoredProcedure;

            CategoriaModel cat = new CategoriaModel();
            // Adiciona os parâmetros para a stored procedure
            cmd.Parameters.AddWithValue("p_nomecategoria", cat.NomeCategoria);
            cmd.Parameters.AddWithValue("p_img", cat.ImgCategoria);

            // Executar a stored procedure
            cmd.ExecuteNonQuery();
        }
    }

    public void InserirPeca(PecaModel peca)
    {
        using (var conexao = new MySqlConnection(_conexaoMySQL))
        {
            conexao.Open();

            using (var cmd = new MySqlCommand("spInsertPeca", conexao))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                // Adiciona os parâmetros que serão passados para a stored procedure
                cmd.Parameters.AddWithValue("@vNomePeca", peca.NomePeca);
                cmd.Parameters.AddWithValue("@vValorPeca", peca.ValorPeca);
                cmd.Parameters.AddWithValue("@vImgPeca", peca.ImgPeca);
                cmd.Parameters.AddWithValue("@vDescricao", peca.Descricao);
                cmd.Parameters.AddWithValue("@vQtdEstoque", peca.QtdEstoque);
                cmd.Parameters.AddWithValue("@vcategoriaid", peca.CategoriaId);

                // Executa o comando para chamar a stored procedure
                cmd.ExecuteNonQuery();
            }
        }
    }

    public bool EditarPeca(PecaModel peca)
    {
        using (var conexao = new MySqlConnection(_conexaoMySQL))
        {
            conexao.Open();
            using (var cmd = new MySqlCommand("spUpdatePeca", conexao))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("vPecaId", peca.PecaId);
                cmd.Parameters.AddWithValue("vNomePeca", peca.NomePeca);
                cmd.Parameters.AddWithValue("vValorPeca", peca.ValorPeca);
                cmd.Parameters.AddWithValue("vImgPeca", peca.ImgPeca);
                cmd.Parameters.AddWithValue("vDescricao", peca.Descricao);
                cmd.Parameters.AddWithValue("vQtdEstoque", peca.QtdEstoque);
                cmd.Parameters.AddWithValue("vCategoriaId", peca.CategoriaId);

                int result = cmd.ExecuteNonQuery();

                return result > 0; // Retorna true se a atualização foi bem-sucedida
            }
        }
    }

    public bool RemoverPeca(int pecaId)
    {
        using (var conexao = new MySqlConnection(_conexaoMySQL))
        {
            conexao.Open();

            using (var cmd = new MySqlCommand("spDeletePeca", conexao))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("vPecaId", pecaId);



                int result = cmd.ExecuteNonQuery();
                return result > 0;
            }
        }
    }
}

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

    public ClienteModel Login(string Email, string Senha, int ClienteId)
    {
        //usando a variavel conexao 
        using (var conexao = new MySqlConnection(_conexaoMySQL))
        {
            //abre a conexão com o banco de dados
            conexao.Open();

            // variavel cmd que receb o select do banco de dados buscando email e senha
            MySqlCommand cmd = new MySqlCommand("select * from tbLogin where Email = @Email and SenhaUsu = @Senha", conexao);

            //os paramentros do email e da senha 
            cmd.Parameters.Add("@Email", MySqlDbType.VarChar).Value = Email;
            cmd.Parameters.Add("@Senha", MySqlDbType.VarChar).Value = Senha;
            cmd.Parameters.Add("@ClienteId", MySqlDbType.Int32).Value = ClienteId;

            //Le os dados que foi pego do email e senha do banco de dados
            MySqlDataAdapter da = new MySqlDataAdapter(cmd);
            //guarda os dados que foi pego do email e senha do banco de dados
            MySqlDataReader dr;

            //instanciando a model cliente
            ClienteModel cliente = new ClienteModel();
            //executando os comandos do mysql e passsando paa a variavel dr
            dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

            //verifica todos os dados que foram pego do banco e pega o email e senha
            while (dr.Read())
            {

                cliente.Email = Convert.ToString(dr["Email"]);
                cliente.SenhaUsu = Convert.ToString(dr["SenhaUsu"]);
                cliente.ClienteId = Convert.ToInt32(dr["ClienteId"]);
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
                cmd.Parameters.AddWithValue("vCPF", cliente.CPF);
                cmd.Parameters.AddWithValue("vSenhaUsu", cliente.SenhaUsu);
                cmd.Parameters.AddWithValue("vTelefone", cliente.Telefone);
                cmd.Parameters.AddWithValue("vNumEnd", cliente.NumEnd);
                cmd.Parameters.AddWithValue("vCompEnd", cliente.CompEnd);
                cmd.Parameters.AddWithValue("vCEP", cliente.CEP);
                cmd.Parameters.AddWithValue("vBairro", cliente.Bairro.Bairro);
                cmd.Parameters.AddWithValue("vCidade", cliente.Cidade.Cidade);
                cmd.Parameters.AddWithValue("vUF", cliente.Estado.UF);

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
            MySqlCommand cmd = new MySqlCommand("SELECT * FROM tbCliente WHERE ClienteId = @ClienteId", conexao);

            // Adiciona o parâmetro para o ID da peça
            cmd.Parameters.Add("@ClienteId", MySqlDbType.Int32).Value = pecaId;

            // Executa a consulta e obtém o leitor de dados
            using (MySqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection))
            {
                if (dr.Read()) // Se houver uma peça com o ID especificado
                {
                    ClienteModel cliente = new ClienteModel();
                    cliente.ClienteId = Convert.ToInt32(dr["ClienteId"]);
                    cliente.CPF= Convert.ToString(dr["CPF"])!;
                    cliente.NomeCli= Convert.ToString(dr["NomeCli"])!;
                    cliente.Email = Convert.ToString(dr["Email"])!;
                    cliente.SenhaUsu= Convert.ToString(dr["SenhaUsu"])!;
                    cliente.Telefone = Convert.ToInt32(dr["telefone"])!;
                    cliente.NumEnd = Convert.ToInt32(dr["NumEnd"])!;
                    cliente.CompEnd = Convert.ToString(dr["CompEnd"])!;
                    cliente.CEP = Convert.ToInt32(dr["CEP"])!;

                    return cliente; // Retorna o cliente encontrada
                }
            }
        }

        // Retorna null se nenhum cliente for encontrada com o ID especificado
        return null;
    }




}

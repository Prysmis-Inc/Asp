using System.Data;
using MySql.Data.MySqlClient;
using HayumiWeb.Models;
using MySqlX.XDevAPI;
namespace HayumiWeb.Repositorio
{
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
                MySqlCommand cmd = new MySqlCommand("select * from tbLogin where Email = @Email and SenhaUsu = @Senha", conexao);

                //os paramentros do email e da senha 
                cmd.Parameters.Add("@Email", MySqlDbType.VarChar).Value = Email;
                cmd.Parameters.Add("@Senha", MySqlDbType.VarChar).Value = Senha;

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
                    cliente.Senha = Convert.ToString(dr["SenhaUsu"]);
                }
                return cliente;
            }
        }

        public void Cadastrar(ClienteModel cliente) 
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL)) 
            {
                conexao.Open();
                MySqlCommand cmd = new MySqlCommand("call ");
            }
        }
    }
}

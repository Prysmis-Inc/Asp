using HayumiWeb.Models;
using MySql.Data.MySqlClient;
using System.Data;

namespace HayumiWeb.Repositorio
{
    public class CategoriaRepositorio : ICategoriaRepositorio
    {
        // essa vai ser a variável da conexão
        private readonly string? _conexaoMySQL;

        //metodo da conexão com banco de dados
        public CategoriaRepositorio(IConfiguration conf) => _conexaoMySQL = conf.GetConnectionString("ConexaoMySQL");

        public List<CategoriaModel> BuscarCategorias()
        {
            //usando a variavel conexao 
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                //abre a conexão com o banco de dados
                conexao.Open();

                // variavel cmd que recebe o select do banco de dados
                MySqlCommand cmd = new MySqlCommand("select * from tbCategoria", conexao);

                //Le os dados que foi pego das categorias
                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                //guarda os dados que foi pego do categoria do banco de dados
                MySqlDataReader dr;

                //instanciando a model categoria
                List<CategoriaModel> listaCategoria = new List<CategoriaModel>();

                //executando os comandos do mysql e passsando paa a variavel dr
                dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                //verifica todos os dados que foram pego do banco e pega a categoria
                while (dr.Read())
                {
                    CategoriaModel categoria = new CategoriaModel();
                    categoria.CategoriaId  = Convert.ToInt32(dr["categoriaid"]);
                    categoria.NomeCategoria  = Convert.ToString(dr["nomecategoria"])!;
                    categoria.ImgCategoria  = Convert.ToString(dr["img_categoria"]);
                    listaCategoria.Add(categoria);
                }

                return listaCategoria;
            }
        }
    }
}

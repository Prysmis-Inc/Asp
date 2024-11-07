using HayumiWeb.Models;
using MySql.Data.MySqlClient;
using System.Data;

namespace HayumiWeb.Repositorio
{
    public class PecaRepositorio : IPecaRepositorio
    {
        // essa vai ser a variável da conexão
        private readonly string? _conexaoMySQL;

        //metodo da conexão com banco de dados
        public PecaRepositorio(IConfiguration conf) => _conexaoMySQL = conf.GetConnectionString("ConexaoMySQL");

        public List<PecaModel> BuscarPecaPorCategoria(int categoriaId)
        {
            //usando a variavel conexao 
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                //abre a conexão com o banco de dados
                conexao.Open();

                // variavel cmd que receb o select do banco de dados buscando email e senha
                MySqlCommand cmd = new MySqlCommand("select * from tbPeca where categoriaid = @categoriaId", conexao);

                //os paramentros do email e da senha 
                cmd.Parameters.Add("@categoriaId", MySqlDbType.Int32).Value = categoriaId;

                //Le os dados que foi pego do categoria do banco de dados
                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                //guarda os dados que foi pego do categoria do banco de dados
                MySqlDataReader dr;

                //instanciando a model peça
                List<PecaModel> listaPeca = new List<PecaModel>();

                //executando os comandos do mysql e passsando paa a variavel dr
                dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                //verifica todos os dados que foram pego do banco e pega a categoria
                while (dr.Read())
                {
                    PecaModel peca = new PecaModel();
                    peca.PecaId  = Convert.ToInt32(dr["PecaId"]);
                    peca.NomePeca = Convert.ToString(dr["NomePeca"])!;
                    peca.ValorPeca = Convert.ToDouble(dr["ValorPeca"])!;
                    peca.ImgPeca = Convert.ToString(dr["img_peca"])!;
                    peca.Descricao = Convert.ToString(dr["descricao"])!;
                    peca.QtdEstoque = Convert.ToInt32(dr["qtd_estoque"])!;
                    peca.CategoriaId = Convert.ToInt32(dr["categoriaid"])!;
                    listaPeca.Add(peca);
                }

                return listaPeca;
            }
        }
    }
}

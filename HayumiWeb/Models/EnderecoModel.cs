using System.ComponentModel.DataAnnotations;

namespace HayumiWeb.Models
{
    public class EnderecoModel
    {
        public decimal CEP { get; set; }
        public string Logradouro { get; set; }
        public int BairroId { get; set; }
        public int CidadeId { get; set; }
        public int UFId { get; set; }

        public BairroModel Bairro { get; set; }
        
        public CidadeModel Cidade { get; set; }

        public EstadoModel Estado { get; set; } 
    }
}

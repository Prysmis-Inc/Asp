using System.ComponentModel.DataAnnotations;

namespace HayumiWeb.Models
{
    public class EnderecoModel
    {
        [Key]
        public decimal CEP { get; set; }

        [Required]
        [StringLength(200)]
        public string Logradouro { get; set; }

        [Required]
        public int BairroId { get; set; }

        [Required]
        public int CidadeId { get; set; }

        [Required]
        public int UFId { get; set; }
    }
}

using System.ComponentModel.DataAnnotations;

namespace HayumiWeb.Models
{
    public class PagamentoModel
    {
        [Key]
        public int BairroId { get; set; }

        [Required]
        [StringLength(200)]
        public string Nome { get; set; }
    }
}

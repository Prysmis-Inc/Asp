using System.ComponentModel.DataAnnotations;

namespace HayumiWeb.Models
{
    public class CidadeModel
    {
        [Key]
        public int CidadeId { get; set; }

        [Required]
        [StringLength(200)]
        public string Nome { get; set; }
    }
}

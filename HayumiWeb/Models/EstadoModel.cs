using System.ComponentModel.DataAnnotations;

namespace HayumiWeb.Models
{
    public class EstadoModel
    {
        [Key]
        public int UFId { get; set; }

        [Required]
        [StringLength(2)]
        public string UF { get; set; }
    }
}

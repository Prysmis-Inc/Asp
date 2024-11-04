using System.ComponentModel.DataAnnotations;

namespace HayumiWeb.Models
{
    public class LoginModel
    {
        [Key]
        public int LoginId { get; set; }

        [Required]
        [StringLength(100)]
        public string Email { get; set; }

        [Required]
        [StringLength(50)]
        public string SenhaUsu { get; set; }

        [Required]
        public bool ClienteStatus { get; set; }

        [Required]
        public int ClienteId { get; set; }
    }
}

using System.ComponentModel.DataAnnotations;

namespace HayumiWeb.Models
{
    public class LoginModel
    {
        public int LoginId { get; set; }
        public string Email { get; set; }
        public string SenhaUsu { get; set; }
        public bool ClienteStatus { get; set; }
        public int ClienteId { get; set; }
    }
}

using System.ComponentModel.DataAnnotations;

namespace HayumiWeb.Models;

public class PecaModel
{
    [Key]
    public int PecaId { get; set; }

    [Required(ErrorMessage = "Campo obrigatório, necessário informar nome da peça")]
    [StringLength(100, MinimumLength = 10, ErrorMessage = "A peça deve ter no máximo 100 caracteres e mínimo 10")]
    public string NomePeca { get; set; }

    [Required(ErrorMessage = "Campo obrigatório, necessário informar nome do fabricante")]
    [StringLength(150, MinimumLength = 10, ErrorMessage = "O fabricante deve ter no máximo 150 caracteres e mínimo 10")]
    public string Fabricante { get; set; }

    [Required(ErrorMessage = "Campo obrigatório, necessário informar nome da SubCategoria")]
    [StringLength(100, MinimumLength = 10, ErrorMessage = "O nome deve ter no máximo 100 caracteres e mínimo 10")]
    public string SubCategoria { get; set; }

    [Required(ErrorMessage = "Campo obrigatório, necessário informar descrição do produto")]
    [StringLength(200, MinimumLength = 10, ErrorMessage = "A descrição deve ter no máximo 200 caracteres e mínimo 10")]
    public string Descricao { get; set; }
}

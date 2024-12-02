using System.ComponentModel.DataAnnotations;

namespace HayumiWeb.Models;

public class PecaModel
{
    [Key]
    public int PecaId { get; set; }

    [Required(ErrorMessage = "Campo obrigatório, necessário informar nome da peça")]
    [StringLength(100, MinimumLength = 10, ErrorMessage = "A peça deve ter no máximo 100 caracteres e mínimo 10")]
    public string NomePeca { get; set; }


    public double ValorPeca { get; set; }

    //[Required(ErrorMessage = "Campo obrigatório, necessário informar nome do img_peca")]
    //[StringLength(150, MinimumLength = 10, ErrorMessage = "O fabricante deve ter no máximo 150 caracteres e mínimo 10")]
    public string ImgPeca { get; set; }

    [Required(ErrorMessage = "Campo obrigatório, necessário informar descrição do produto")]
    [StringLength(200, MinimumLength = 10, ErrorMessage = "A descrição deve ter no máximo 200 caracteres e mínimo 10")]
    public string Descricao { get; set; }

    [Required(ErrorMessage = "Campo obrigatório, necessário informar a quantidade de estoque")]
    //[StringLength(100, MinimumLength = 10, ErrorMessage = "O nome deve ter no máximo 100 caracteres e mínimo 10")]
    public int QtdEstoque { get; set; }

    public int CategoriaId { get; set; }
    public CategoriaModel Categoria { get; set; }
}

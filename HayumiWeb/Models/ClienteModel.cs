using System.ComponentModel.DataAnnotations;
using System.Numerics;
using System.Runtime.InteropServices;

namespace HayumiWeb.Models;

public class ClienteModel
{

    public int ClienteId { get; set; }
    [Required(ErrorMessage = "O campo NomeCli é obrigatório.")]
    
    public string NomeCli { get; set; }

    [Required(ErrorMessage = "O campo CPF é obrigatório.")]
    [RegularExpression(@"^\d{11}$", ErrorMessage = "O CPF deve conter exatamente 11 dígitos numéricos.")]
    public decimal CPF { get; set; }

    [Required(ErrorMessage = "O campo Email é obrigatório.")]
    [EmailAddress(ErrorMessage = "O formato do email é inválido.")]
    [MaxLength(100, ErrorMessage = "O campo Email não pode ter mais de 100 caracteres.")]
    public string Email { get; set; }

    [Required(ErrorMessage = "O campo Senha é obrigatório.")]
    [StringLength(100, MinimumLength = 6, ErrorMessage = "A senha deve ter entre 6 e 100 caracteres.")]
    public string SenhaUsu { get; set; }

    public DateTime DataNasc { get; set; }
    [Required(ErrorMessage = "O campo Telefone é obrigatório.")]
    public BigInteger Telefone { get; set; }
    [Required(ErrorMessage = "O campo Número é obrigatório.")]
    [Range(1, int.MaxValue, ErrorMessage = "O número do endereço deve ser maior que 0.")]
    public int NumEnd { get; set; }
    [StringLength(200, ErrorMessage = "O campo Complemento não pode ter mais de 200 caracteres.")]
    public string CompEnd { get; set; }
    [Required(ErrorMessage = "O campo CEP é obrigatório.")]
    [Range(10000000, 99999999, ErrorMessage = "O CEP deve ter 8 dígitos.")]
    public decimal CEP { get; set; }
    [Required(ErrorMessage = "O campo Logradouro é obrigatório.")]
    [StringLength(200, MinimumLength = 3, ErrorMessage = "O logradouro deve ter entre 3 e 200 caracteres.")]
    public string Logradouro { get; set; }
    public bool? ClienteStatus { get; set; }

 // Referência ao EnderecoModel
    public BairroModel? Bairro { get; set; }
    public CidadeModel? Cidade { get; set; }
 
    public EstadoModel Estado { get; set; } = new EstadoModel();






  
}
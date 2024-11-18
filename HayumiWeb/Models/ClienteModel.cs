using System.ComponentModel.DataAnnotations;

namespace HayumiWeb.Models;

public class ClienteModel
{

    public int ClienteId { get; set; }
    [Required(ErrorMessage = "O campo Nome é obrigatório.")]
    public string NomeCli { get; set; }

    [Required(ErrorMessage = "O campo CPF é obrigatório.")]
    public string CPF { get; set; }

    [Required(ErrorMessage = "O campo Email é obrigatório.")]
    public string Email { get; set; }

    [Required(ErrorMessage = "O campo Senha é obrigatório.")]
    public string SenhaUsu { get; set; }

    public DateTime DataNasc { get; set; }
    public long Telefone { get; set; }
    public int NumEnd { get; set; }
    public string CompEnd { get; set; }
    public decimal CEP { get; set; }
    public bool? ClienteStatus { get; set; }

    [Required]
    public EnderecoModel Endereco { get; set; } = new EnderecoModel(); // Referência ao EnderecoModel
    public BairroModel Bairro { get; set; }
    public CidadeModel Cidade { get; set; }


    [Required]
    public EstadoModel Estado { get; set; } = new EstadoModel();





  
}
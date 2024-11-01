﻿using System.ComponentModel.DataAnnotations;

namespace HayumiWeb.Models;

public class ClienteModel
{
    public int ClienteId { get; set; }

    [Required(ErrorMessage = "O seu nome deve ser informado")]
    [Display(Name = "Nome *")]
    [StringLength(100, MinimumLength = 10, ErrorMessage = "O nome deve ter no máximo 100 caracteres")]
    public string? Nome { get; set; }

    [Required(ErrorMessage = "O seu CPF deve ser informado")]
    [Display(Name = "CPF *")]
    [RegularExpression(@"\d{3}\.\d{3}\.\d{3}\-\d{2}", ErrorMessage = "O CPF deve estar no formato 000.000.000-00")]
    public string? CPF { get; set; }

    [Required(ErrorMessage = "O seu Email deve ser informado")]
    [Display(Name = "E-Mail *")]
    [EmailAddress(ErrorMessage = "Informe um email válido")]
    public string? Email { get; set; }

    [Required(ErrorMessage = "Sua senha deve ser informada")]
    [Display(Name = "Senha *")]
    [StringLength(30, MinimumLength = 8, ErrorMessage = "A senha deve ter no máximo 30 caracteres e mínimo 8")]
    public string? Senha { get; set; }

    [Required(ErrorMessage = "A sua data de nascimento deve ser informada")]
    [Display(Name = "Data de Nascimento *")]
    [DataType(DataType.Date, ErrorMessage = "Informe uma data válida")]
    public DateOnly DataNascimento { get; set; }

    [Required(ErrorMessage = "O seu telefone deve ser informado")]
    [Display(Name = "Telefone *")]
    [RegularExpression(@"\(\d{2}\) \d{4,5}\-\d{4}", ErrorMessage = "O telefone deve estar no formato (00) 00000-0000 ou (00) 0000-0000")]
    public string? Telefone { get; set; }

    public int? NumEnd { get; set; }
    [Required(ErrorMessage = "O seu complemento de endereço deve ser informado")]
    [Display(Name = "Complemento endereço *")]
    [StringLength(200, ErrorMessage = "O complemento de endereço deve ter no máximo 200 caracteres")]
    public string? ComplementoEndereco { get; set; }


    [Required(ErrorMessage = "O seu CEP deve ser informado")]
    [Display(Name = "CEP *")]
    [RegularExpression(@"\d{5}-\d{3}", ErrorMessage = "O CEP deve estar no formato 00000-000")]
    public string? CEP { get; set; }




}
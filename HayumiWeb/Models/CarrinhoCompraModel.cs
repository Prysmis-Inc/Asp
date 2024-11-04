using System.ComponentModel.DataAnnotations;

namespace HayumiWeb.Models
{
    public class CarrinhoCompraModel
    {  
            [Key]
            public int CarrinhoId { get; set; }

            [Required]
            [StringLength(200)]
            public string ProdutosSelecionados { get; set; }

            [StringLength(200)]
            public string ProdutosSelecionados1 { get; set; }

            [StringLength(200)]
            public string ProdutosSelecionados2 { get; set; }

            [StringLength(200)]
            public string ProdutosSelecionados3 { get; set; }

            [StringLength(200)]
            public string ProdutosSelecionados4 { get; set; }

            [Required]
            public int QtdPeca { get; set; }

            [Required]
            public decimal ValorTotalCompra { get; set; }

            [Required]
            public int ClienteId { get; set; }

            [Required]
            public int PecaId { get; set; }

            public int? PecaId1 { get; set; }

            public int? PecaId2 { get; set; }

            public int? PecaId3 { get; set; }

            public int? PecaId4 { get; set; }
    }
}

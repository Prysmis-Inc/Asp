namespace HayumiWeb.Models
{
    public class CarrinhoCompra
    {
        public int CarrinhoId { get; set; }
        public int QtdPeca { get; set; }
        public int ClienteId { get; set; }
        public int PecaId { get; set; }

        public PecaModel? Peca { get; set; }
        public ClienteModel? Cliente { get; set; }
    }
}

namespace HayumiWeb.Models
{
    public class PecaViewModel
    {
        // Lista
        public List<PecaModel> Pecas { get; set; }

        // Cadastro
        public PecaModel Peca { get; set; }
        public IFormFile ImagemFormFile { get; set; }
    }
}

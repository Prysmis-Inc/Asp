namespace HayumiWeb.Models;

public class TrocaModel
{
    public int IdTroca { get; set; }
    public string Itens { get; set; }
    public DateTime DataTroca { get; set; }
    public string Motivo { get; set; }
    public bool Status { get; set; }
    public int NF {  get; set; }
}

function confirmarPagamento() {
    // Pegando os valores dos campos
    const cvv = document.getElementById("cvv").value;
    const nomeTitular = document.getElementById("nome-titular").value;
    const bandeira = document.getElementById("bandeira").value;
    const numeroCartao = document.getElementById("numero-cartao").value;
    const validadeCartao = document.getElementById("validade-cartao").value;

    // Verifica se todos os campos foram preenchidos
    if (!cvv || !nomeTitular || !bandeira || !numeroCartao || !validadeCartao) {
        alert("Por favor, preencha todos os campos!");
        return;
    }

    // Lógica de processamento do pagamento
    alert("Pagamento confirmado com sucesso!");
}
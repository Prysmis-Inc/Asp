function copiarLinhaDigitavel() {
    const linhaDigitavel = document.getElementById("linha-digitavel").textContent;

    // Copiar para a área de transferência usando a Clipboard API
    navigator.clipboard.writeText(linhaDigitavel).then(() => {
        alert("Linha de código copiada para a área de transferência!");
    }).catch(err => {
        alert("Erro ao copiar a linha de código: " + err);
    });
}
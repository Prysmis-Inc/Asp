
    function copiarPix() {
            const pixCode = document.getElementById("pix-code").textContent;

            // Copiar para a área de transferência usando a Clipboard API
            navigator.clipboard.writeText(pixCode).then(() => {
        alert("Código Pix copiado para a área de transferência!");
            }).catch(err => {
        alert("Erro ao copiar o código: " + err);
            });
        }

$(".payment-option").on("click", function () {
    var radioId = $(this).data("target");
    $(radioId).prop("checked", true);  // Marca o radio correspondente como 'checked'
});
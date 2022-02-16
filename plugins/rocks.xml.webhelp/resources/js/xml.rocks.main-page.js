function flipCard(button) {
    var card = button.closest('.card');
    $(card).toggleClass('is-flipped');
}
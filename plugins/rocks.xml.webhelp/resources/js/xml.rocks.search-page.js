var url_string = window.location.href,
    url = new URL(url_string),
    key = url.searchParams.get("key");

$(document).ready(function() {
    // Press body search button on enter
    // Get the input field
    var bodyInput = document.getElementById("body-search-input");

    // Execute a function when the user releases a key on a keyboard
    bodyInput.addEventListener("keyup", function(event) {
        // Number 13 is the "Enter" key on a keyboard
        if (event.keyCode === 13) {
            // Trigger the button element with a click
            document.getElementById("body-search-button").click();
            console.log('123');
        }
    });
});

// If keyword exists show 'document(s) found for [keyword]' text
if(key !== '') {
    document.getElementById('search-results-info').classList.add('show');
    document.getElementById('search-results').classList.add('show');

    // Insert search key value in #keyword-text element
    $('#keyword-text').html(key);

    // Insert search key value in search input
    $('.search-input-container input.search-input').val(key);

    document.getElementById('body-search-cancel-button').classList.add('show');
} else {
    // Show string 'Search keyword cannot be empty'
    document.getElementsById('empty-keyword').classList.add('show');
}
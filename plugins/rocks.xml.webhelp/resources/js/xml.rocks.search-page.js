var url_string = window.location.href,
    url = new URL(url_string),
    key = url.searchParams.get("key");

// If keyword exists show 'document(s) found for [keyword]' text
if(key !== '') {
    document.getElementById('search-results-info').classList.add('show');
    document.getElementById('search-results').classList.add('show');

    // Insert search key value in #keyword-text element
    $('#keyword-text').html(key);

    // Insert search key value in search input
    $('.search-input-container input.search-input').val(key);
} else {
    // Show string 'Search keyword cannot be empty'
    document.getElementsById('empty-keyword').classList.add('show');
}
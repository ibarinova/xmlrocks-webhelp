var url_string = window.location.href,
    url = new URL(url_string),
    key = url.searchParams.get("key");


var idx = lunr(function () {
/*    this.use(lunr.ar);
    this.use(lunr.da);
    this.use(lunr.de);
    this.use(lunr.du);
    this.use(lunr.es);
    this.use(lunr.fi);
    this.use(lunr.fr);
    this.use(lunr.hi);
    this.use(lunr.it);
    this.use(lunr.ja);
    this.use(lunr.jp);
    this.use(lunr.nl);
    this.use(lunr.no);
    this.use(lunr.pt);
    this.use(lunr.ro);
    this.use(lunr.ru);
    this.use(lunr.sv);
    this.use(lunr.ta);
    this.use(lunr.th);
    this.use(lunr.tr);
    this.use(lunr.vi);
    this.use(lunr.zh);*/

    this.ref('name')
    this.field('text')

    documents.forEach(function (doc) {
        this.add(doc);
    }, this)
})

var searchInputValue = $('#body-search-input').val();
var searchRes = idx.search(searchInputValue);

// Add search document number
var searchDocNumber = document.getElementById("search-documents-number");
var searchDocNumberValue = document.createTextNode(searchRes.length);
searchDocNumber.appendChild(searchDocNumberValue);

var i = 0;

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
        }
    });

    (function(name) {
        var container = $('#pagination-' + name);
        container.pagination({
            dataSource: searchRes,
            locator: searchRes,
            totalNumber: 50,
            pageSize: 10,
            showPageNumbers: true,
            showPrevious: true,
            showNext: true,
            showNavigator: true,
            showFirstOnEllipsisShow: true,
            showLastOnEllipsisShow: true,
            ajax: {
                beforeSend: function() {
                    container.prev().html('Loading data from flickr.com ...');
                }
            },
            callback: function(response, pagination) {
                var dataHtml = '<div class="search-result-block">';

                $.each(response, function (index, item) {
                    var itemRef = item.ref;
                    var searchResultHref = documents.filter(iT => iT.name === itemRef).map(iT => iT.href);
                    var searchResultBodyText = documents.filter(iT => iT.name === itemRef).map(iT => iT.text);

                    dataHtml += '<p class="search-result-title"><a href="'+ searchResultHref +'">' + item.ref + '</a></p>';
                    dataHtml += '<p class="search-result-body">' + searchResultBodyText + '</p>';
                });

                dataHtml += '</div>';
                container.prev().html(dataHtml);
            }
        })
    })('demo2');
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

searchRes.forEach(function () {
    /*console.log(searchRes[i].ref);*/
    /*console.log(documents[i]["text"]);*/
    /*console.log(documents.filter(item => item.name === searchRes[i].ref).map(item => item.text));*/

    var searchResultBlock = document.createElement("div");
    var searchResultTitle = document.createElement("p");
    var anchor = document.createElement("a");
    var searchResultTitleText = document.createTextNode(searchRes[i].ref);

    searchResultBlock.classList.add('search-result-block');
    searchResultBlock.appendChild(searchResultTitle).classList.add('search-result-title');
    searchResultTitle.appendChild(anchor);
    anchor.appendChild(searchResultTitleText);
    anchor.href = documents.filter(item => item.name === searchRes[i].ref).map(item => item.href);

    var searchResultBody = document.createElement("p");
    var searchResultBodyText = document.createTextNode(documents.filter(item => item.name === searchRes[i].ref).map(item => item.text));
    searchResultBlock.appendChild(searchResultBody).classList.add('search-result-body');
    searchResultBody.appendChild(searchResultBodyText);

    var searchResults = document.getElementById("search-results");
    searchResults.appendChild(searchResultBlock);

    i++;
}, this)
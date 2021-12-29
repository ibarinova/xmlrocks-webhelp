var backToTopButton = document.getElementById("button-back-to-top"),
    state = null;

window.onscroll = function() {
    if (document.documentElement.scrollTop > 20) {
        backToTopButton.style.display = "block";
    } else {
        backToTopButton.style.display = "none";
    }
}

function backToTop() {
    document.documentElement.scrollTo({top: 0, behavior: 'smooth'});
}

function hideOrShowTOC() {
    if($('#toc-wrapper').hasClass('hidden')) {
        $('#toc-wrapper').removeClass('hidden');
        $('#button-hide-show-toc').removeClass('hidden');
        $('#button-expand-collapse').removeClass('inactive');
        $('#button-show-active').removeClass('inactive');
    } else {
        $('#toc-wrapper').addClass('hidden');
        $('#button-hide-show-toc').addClass('hidden');
        $('#button-expand-collapse').addClass('inactive');
        $('#button-show-active').addClass('inactive');
    }
}

function showActive() {
    if (!($('#button-show-active').hasClass('inactive'))){
        $('.toc-container nav li.expanded').removeClass('expanded');
        $('.active').parents('nav li').addClass('expanded').addClass('ancestor-of-active');
    }
}

function expandCollapseAll() {
    if (!($('#button-expand-collapse').hasClass('inactive'))) {
        if ($('#button-expand-collapse').hasClass('expanded')) {
            $('.toc-container nav li.expanded').removeClass('expanded');
            $('#button-expand-collapse').removeClass('expanded');
        } else {
            $('.toc-container nav li').addClass('expanded');
            $('#button-expand-collapse').addClass('expanded');
        }
    }
}

//Create PDF from HTML topic content
function getPDF() {
    var idTopicArticle = document.getElementById("topic-article");
    var removedChild = idTopicArticle.querySelector('.related-links');

    idTopicArticle.removeChild(idTopicArticle.querySelector('.related-links'));

    var htmlWidth = $("#topic-article").width();
    var htmlHeight = $("#topic-article").height();

    var topLeftMargin = 15;
    var pdfWidth = htmlWidth + (topLeftMargin * 2);
    var pdfHeight = (pdfWidth * 1.5) + (topLeftMargin * 2);
    var canvasImageWidth = htmlWidth;
    var canvasImageHeight = htmlHeight;

    var totalPDFPages = Math.ceil(htmlHeight / pdfHeight) - 1;

    var topicName = document.getElementsByClassName("title topictitle1")[0].textContent;

    topicName = topicName.replace(/\s+/g, '-');

    html2canvas(idTopicArticle, {allowTaint: true}).then(function (canvas) {
        canvas.getContext('2d');
        var imgData = canvas.toDataURL("image/jpeg", 1.0);
        var pdf = new jsPDF('p', 'pt', [pdfWidth, pdfHeight]);
        pdf.addImage(imgData, 'JPG', topLeftMargin, topLeftMargin, canvasImageWidth, canvasImageHeight);

        for (var i = 1; i <= totalPDFPages; i++) {
            pdf.addPage(pdfWidth, pdfHeight);
            pdf.addImage(imgData, 'JPG', topLeftMargin, -(pdfHeight * i) + (topLeftMargin * 4), canvasImageWidth, canvasImageHeight);
        }

        pdf.save(topicName + ".pdf");
    });
    // Append 'related-links' to the page after downloading current topic
    idTopicArticle.appendChild(removedChild);
};

// Function for dropdown menu for 'download' button
function dropdownDownload() {
    document.getElementById("menu-dropdown-download").classList.toggle("show");
}

// Close the dropdown menu if the user clicks outside
window.onclick = function (event) {
    if (!event.target.matches('.button-dropdown-download')) {
        closeDropDown("dropdown-content-download");
    }

    if (!event.target.matches('.button-dropdown-share-google-drive')) {
        closeDropDown("dropdown-content-google-drive");
    }
};

function closeDropDown(className){
    var dropdowns = document.getElementsByClassName(className);

    for (var i = 0; i < dropdowns.length; i++) {
        var openDropdown = dropdowns[i];
        if (openDropdown.classList.contains('show')) {
            openDropdown.classList.remove('show');
        }
    }
}

// Function for dropdown menu for 'save to Google Drive' button
function dropdownGoogleDrive() {
    document.getElementById("menu-dropdown-google-drive").classList.toggle("show");
}

// Dynamically update page from the TOC
$('body').on('click', 'div.toc-container nav li a', updatePageReloadingBehaviour);

// Dynamically update page from the breadcrumbs links
$('body').on('click', '.head-breadcrumb a.link', updatePageReloadingBehaviour);

// Dynamically update page from the nav buttons links
$('body').on('click', '.top-nav-buttons-container a', updatePageReloadingBehaviour);
$('body').on('click', '.bottom-nav-buttons-container a', updatePageReloadingBehaviour);

// Open search page when search button is pressed
$('body').on('click', '#search-button', runSearch);

function runSearch() {
    var searchInputValue = $('input.search').val();
    location.href = "search.html?key=" + searchInputValue;
}

// Update link transition event if page is not opened as file
function updatePageReloadingBehaviour(event) {
    if (window.location.protocol != 'file:') {
        var currentHref = $(this).attr('href');
        event.preventDefault();
        window.history.pushState(currentHref, "", currentHref);
        reloadDynamically(currentHref);
    }
}

// Expand topics in the TOC
function applyExpandedClass(id){
    if ($(id).parent().parent().hasClass('expanded')) {
        // Remove .expanded from current TOC topic
        $(id).parent().parent().removeClass('expanded');
    } else {
        // Add .expanded to current TOC topic
        $(id).parent().parent().addClass('expanded');
    }
}

$(document).ready(function() {
    // Expand all parent li's
    $('.active').parents('nav li').addClass('expanded ancestor-of-active');

    // Count main container min-height (needed for correct displaying of footer if the content is too short)
    var height = $(window).height() - ($("header").outerHeight() + $('div.breadcrumb-container').outerHeight() + $('div.top-nav-buttons-container-wrapper').outerHeight() + $('div.main-button-container').outerHeight() + $("footer").outerHeight() + 150);
    $("main.container").css("min-height", height + "px");

    // Reveal active topic in the TOC when page reloads
    showActive;

    // Count header padding for references on element inside topic
    if (window.location.href.indexOf("#") > -1) {
        var url = window.location.href,
            currentId = url.substring(url.lastIndexOf('#') + 1),
            $currentElem = $('#' + currentId),
            headerHeight = $('header').outerHeight();

        $("html, body").animate({ scrollTop: $currentElem.offset().top - headerHeight}, 0);
    }

    // Search page code
    if ($('body#search-page')) {
        var url_string = window.location.href,
            url = new URL(url_string),
            key = url.searchParams.get("key");

        // If keyword exists show 'document(s) found for [keyword]' text
        if(key !== '') {
            $('#search-results-info').addClass('show');
            $('#search-results').addClass('show');

            // Insert search key value in #keyword-text element
            $('#keyword-text').html(key);

            // Insert search key value in search input
            $('.search-input-container input.search-input').val(key);
        } else {
            // Show string 'Search keyword cannot be empty'
            $('#empty-keyword').addClass('show');
        }
    }

    // Press search button on enter
    // Get the input field
    var input = document.getElementById("header-search-input");

    // Execute a function when the user releases a key on the keyboard
    input.addEventListener("keyup", function(event) {
        // Number 13 is the "Enter" key on the keyboard
        if (event.keyCode === 13) {
            // Trigger the button element with a click
            document.getElementById("search-button").click();
        }
    });
});

function reloadDynamically(href){
    jQuery.post(href, function (content) {
        var htmlContent = $.parseHTML(content),
            articleContent = $(htmlContent).find('article').contents(),
            breadcrumbsContent = $(htmlContent).find('.head-breadcrumb').contents(),
            topNavButtonsContainerContent = $(htmlContent).find('.top-nav-buttons-container').contents(),
            bottomNavButtonsContainerContent = $(htmlContent).find('.bottom-nav-buttons-container').contents(),
            titleContent = $(htmlContent).filter('title').contents(),
            listItemID = $(htmlContent).find('.toc-container .active').attr('id');

        $('title').html(titleContent);

        $('.head-breadcrumb').html(breadcrumbsContent);

        $('.top-nav-buttons-container').html(topNavButtonsContainerContent);
        $('.bottom-nav-buttons-container').html(bottomNavButtonsContainerContent);

        $('article').html(articleContent);

        $('.toc-container').find('.active').parents('nav li').removeClass('ancestor-of-active');
        $('.toc-container').find('.active').removeClass('active');

        $('.toc-container').find('#' + listItemID).addClass('active');
        $('.toc-container').find('#' + listItemID).parents('nav li').addClass('expanded ancestor-of-active');
    }, 'html')
}
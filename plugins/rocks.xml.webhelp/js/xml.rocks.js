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
function exportPdf() {
    var idTopicArticle = document.getElementById("topic-article"),
        topicName = document.getElementsByClassName("title topictitle1")[0].textContent;

    topicName = topicName.replace(/\s+/g, '-');

    // Hide related links from the PDF
    $('.related-links').addClass('non-displayed');

    kendo.drawing
        .drawDOM("#topic-article",
            {
                paperSize: "A4",
                margin: {top: "1cm", bottom: "1cm", right: "1cm", left: "1cm"},
                scale: 0.8,
                height: 500
            })
        .then(function (group) {
            kendo.drawing.pdf.saveAs(group, topicName + ".pdf");
            $('.related-links.non-displayed').removeClass('non-displayed');
        });
}

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
$('body').on('click', '#sticky-search-button', runStickySearch);

function runSearch() {
    var searchInputValue = $('input.search').val();
    location.href = "search.html?key=" + searchInputValue;
}

function runStickySearch() {
    var searchInputValue = $('.topic-page-sticky-search-container.expanded .search-input').val();
    location.href = "search.html?key=" + searchInputValue;
}

// Show 'X' button inside header search input if input contains text
$('#header-search-input').keyup(function() {
    if ($(this).val() != '') {
        $('#search-cancel-button').addClass('show');
    } else {
        $('#search-cancel-button').removeClass('show');
    }
});

// Clear search input and hide 'X' button from the header search input
$('#search-cancel-button').click(function () {
    $('#header-search-input').val('');
    $('#search-cancel-button').removeClass('show');
});

// Show 'X' button inside body search input if input contains text
$('.topic-page-sticky-search-container .search-input').keyup(function() {
    if ($(this).val() != '') {
        $('#sticky-search-cancel-button').addClass('show');
    } else {
        $('#sticky-search-cancel-button').removeClass('show');
    }
});

// Clear search input and hide 'X' button from the body search input
$('#sticky-search-cancel-button').click(function () {
    $('.topic-page-sticky-search-container .search-input').val('');
    $('#sticky-search-cancel-button').removeClass('show');
});

// Update link transition event if page is not opened as file
function updatePageReloadingBehaviour(event) {
    if (window.location.protocol != 'file:') {
        var currentHref = $(this).attr('href');
        event.preventDefault();
        window.history.pushState(currentHref, "", currentHref);
        reloadDynamically(currentHref);
        $('.shading-container-wrapper').removeClass('grey');
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

function expandCollapseSearch() {
    if ($('.topic-page-sticky-search-container').hasClass('expanded')) {
        // Remove .expanded from current TOC topic
        $('.topic-page-sticky-search-container').removeClass('expanded');
        $('.expand-collapse-search-container').removeClass('expanded');
    } else {
        // Add .expanded to current TOC topic
        $('.topic-page-sticky-search-container').addClass('expanded');
        $('.expand-collapse-search-container').addClass('expanded');
    }
}

$(document).ready(function() {
    var height;

    // Expand all parent li's
    $('.active').parents('nav li').addClass('expanded ancestor-of-active');

    // Count main container min-height (needed for correct displaying of footer if the content is too short)
    if($('div.breadcrumb-container').length && $('div.top-nav-buttons-container-wrapper').length && $('div.main-button-container').length) {
        height = $(window).height() - ($("header").outerHeight(true) + $('div.breadcrumb-container').outerHeight(true) + $('div.top-nav-buttons-container-wrapper').outerHeight(true) + $('div.main-button-container').outerHeight(true) + $('#back-to-top-button-container').outerHeight(true) + $("footer").outerHeight(true) + 36);
    } else {
        height = $(window).height() - ($("header").outerHeight(true) + $('#back-to-top-button-container').outerHeight(true) + $("footer").outerHeight(true) + 24);
    }

    // Apply min-height value to the main element
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

    // Get the sticky element
    const stickyElm = document.querySelector('.main-button-container-wrapper');

    // Add class 'is-sticky' if buttons bar reaches the top of the viewport
    const observer = new IntersectionObserver(
        ([e]) => e.target.classList.toggle('is-sticky', e.intersectionRatio < 1),
        {threshold: [1]}
    );

    if(stickyElm !== null) {
        observer.observe(stickyElm);
    }
});

function reloadDynamically(href){
    jQuery.post(href, function (content) {
        var htmlContent = $.parseHTML(content),
            articleContent = $(htmlContent).find('#article-wrapper').contents(),
            breadcrumbsContent = $(htmlContent).find('.head-breadcrumb').contents(),
            topNavButtonsContainerContent = $(htmlContent).find('.top-nav-buttons-container').contents(),
            titleContent = $(htmlContent).filter('title').contents(),
            listItemID = $(htmlContent).find('.toc-container .active').attr('id');

        $('title').html(titleContent);

        $('.head-breadcrumb').html(breadcrumbsContent);

        $('.top-nav-buttons-container').html(topNavButtonsContainerContent);

        $('#article-wrapper').html(articleContent);

        $('.toc-container').find('.active').parents('nav li').removeClass('ancestor-of-active');
        $('.toc-container').find('.active').removeClass('active');

        $('.toc-container').find('#' + listItemID).addClass('active');
        $('.toc-container').find('#' + listItemID).parents('nav li').addClass('expanded ancestor-of-active');
    }, 'html')
}

function flipCard(button) {
    var card = button.closest('.card');
    $(card).toggleClass('is-flipped');
}

// Adding class for mobile breadcrumbs
function showBreadcrumbs(button) {
    if ($('.head-breadcrumbs-child-elements').hasClass('show')) {
        $('.head-breadcrumbs-child-elements').removeClass('show');
        $('.head-breadcrumbs-child-elements').children().removeClass('show');
    } else {
        $('.head-breadcrumbs-child-elements').addClass('show');
        $('.head-breadcrumbs-child-elements').children().addClass('show');
        $('.shading-container-wrapper').addClass('grey');

    }
}

// Close the mobile breadcrumbs if the user clicks outside block
window.onclick = function (event) {
    console.log(event.target);
    if (!event.target.closest('.child-elements')
        && !event.target.matches('.three-dots-separator')) {
        closeSpan("head-breadcrumbs-child-elements");

    }
};

function closeSpan(className){
    var breadcrumbs = document.getElementsByClassName(className);
    for (var i = 0; i < breadcrumbs.length; i++) {
        var openBreadcrumbs = breadcrumbs[i];
        if (openBreadcrumbs.classList.contains('show')) {
            openBreadcrumbs.classList.remove('show');
            $('.shading-container-wrapper').removeClass('grey');
        }
    }
}

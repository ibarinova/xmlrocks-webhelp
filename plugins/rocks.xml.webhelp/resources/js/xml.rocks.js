var backToTopButton = document.getElementById("button-back-to-top"),
    state = null,
    $window = $(window),
    previousWidth = $window.width(),
    topicScrollPosition = 0;

$(document).ready(function() {
    var height;

    // Expand all parent li's
    $('.active').parents('nav li').addClass('expanded ancestor-of-active');

    // Count main container min-height (needed for correct displaying of footer if the content is too short)
    if($('div.breadcrumb-container').length && $('div.top-nav-buttons-container-wrapper').length && $('div.main-button-container').length) {
        height = $window.height() - ($("header").outerHeight(true) + $('div.breadcrumb-container').outerHeight(true) + $('div.top-nav-buttons-container-wrapper').outerHeight(true) + $('div.main-button-container').outerHeight(true) + $('#back-to-top-button-container').outerHeight(true) + $("footer").outerHeight(true) + 36);
    } else {
        height = $window.height() - ($("header").outerHeight(true) + $('#back-to-top-button-container').outerHeight(true) + $("footer").outerHeight(true) + 24);
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

    // Press search button on enter
    // Get the input field
    var input = document.getElementById("header-search-input");

    // Execute a function when the user releases a key on a keyboard
    input.addEventListener("keyup", function(event) {
        // Number 13 is the "Enter" key on a keyboard
        if (event.keyCode === 13) {
            // Trigger the button element with a click
            document.getElementById("search-button").click();
        }
    });

    // Hide mobile TOC on click on shading-container-wrapper
    $('#shading-wrapper.toc').click(function () {
        hideMobileTOC();
    });
});

window.onscroll = function() {
    // On scroll turn on/off "Back to top" button
    if (document.documentElement.scrollTop > 20) {
        backToTopButton.style.display = "block";
    } else {
        backToTopButton.style.display = "none";
    }

    // On scroll show/hide search button in the main buttons container
    if (document.querySelector('.main-button-container-wrapper') !== null) {
        if ($window.scrollTop() >= $('.main-button-container-wrapper').offset().top) {
            document.getElementsByClassName('main-button-container-wrapper')[0].classList.add('is-sticky');
        } else {
            document.getElementsByClassName('main-button-container-wrapper')[0].classList.remove('is-sticky');
            document.getElementsByClassName('topic-page-sticky-search-container')[0].classList.remove('expanded');
            document.getElementsByClassName('expand-collapse-search-container')[0].classList.remove('expanded');
            $('.topic-page-sticky-search-container .search-input').val('');
        }
    }
}

// Save scroll position before printing
window.onbeforeprint = function () {
    topicScrollPosition = $window.scrollTop();
    document.getElementById('article-wrapper').classList.add('no-transition');
    setTimeout(function(){
        document.getElementById('article-wrapper').classList.remove('no-transition');
    }, 2000);
}

// Return original scroll position
window.onafterprint = function () {
    $window.scrollTop(topicScrollPosition);
}

function backToTop() {
    document.documentElement.scrollTo({top: 0, behavior: 'smooth'});
}

function hideOrShowTOC() {
    document.getElementById('toc-wrapper').classList.toggle('hidden');
    document.getElementById('button-hide-show-toc').classList.toggle('hidden');
    document.getElementById('button-expand-collapse').classList.toggle('inactive');
    document.getElementById('button-show-active').classList.toggle('inactive');
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
            document.getElementById('button-expand-collapse').classList.remove('expanded');
        } else {
            $('.toc-container nav li').addClass('expanded');
            document.getElementById('button-expand-collapse').classList.add('expanded');
        }
    }
}

// Create a PDF file from the HTML topic content
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
$('body').on('click', '#body-search-button', runBodySearch);
$('body').on('click', '#sticky-search-button', runStickySearch);

function runSearch() {
    var searchInputValue = $('input.search').val();
    location.href = "search.html?key=" + searchInputValue;
}

function runBodySearch() {
    var searchInputValue = $('#body-search-input').val();
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
        document.getElementById('sticky-search-cancel-button').classList.add('show');
    } else {
        document.getElementById('sticky-search-cancel-button').classList.remove('show');
    }
});

// Show 'X' button inside body search input if input contains text
$('#body-search-input').keyup(function() {
    if ($(this).val() != '') {
        document.getElementById('body-search-cancel-button').classList.add('show');
    } else {
        document.getElementById('body-search-cancel-button').classList.remove('show');
    }
});

// Show 'X' button inside body search input if input contains text
$('#body-search-input').keyup(function() {
    if ($(this).val() != '') {
        document.getElementById('body-search-cancel-button').classList.add('show');
    } else {
        document.getElementById('body-search-cancel-button').classList.remove('show');
    }
});

// Clear search input and hide 'X' button from the body search input
$('#body-search-cancel-button').click(function () {
    $('#body-search-input').val('');
    document.getElementById('body-search-cancel-button').classList.remove('show');
});

// Clear search input and hide 'X' button from the body search input
$('#sticky-search-cancel-button').click(function () {
    $('.topic-page-sticky-search-container .search-input').val('');
    document.getElementById('sticky-search-cancel-button').classList.remove('show');
});

// Update link transition event if page is not opened as file
function updatePageReloadingBehaviour(event) {
    if (window.location.protocol != 'file:') {
        var currentHref = $(this).attr('href');
        event.preventDefault();
        window.history.pushState(currentHref, "", currentHref);
        reloadDynamically(currentHref);
        document.getElementsByClassName('shading-container-wrapper')[0].classList.remove('grey');
    }
}

// Expand topics in the TOC
function applyExpandedClass(id){
    // Add or remove .expanded to current TOC topic
    $(id).parent().parent().toggleClass('expanded');
}

function expandCollapseSearch() {
    document.getElementsByClassName('topic-page-sticky-search-container')[0].classList.toggle('expanded');
    document.getElementsByClassName('expand-collapse-search-container')[0].classList.toggle('expanded');
    document.getElementById('sticky-search-input').focus();
}

// mobile-menu-button implementation
$('#mobile-menu-button').click(function () {
    if($('#toc-wrapper').hasClass('hidden')) {
        showMobileTOC();
    } else {
        hideMobileTOC();
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

        if($('#mobile-menu-button').hasClass('active')) {
            hideMobileTOC();
        }

        $window.scrollTop(0);
        topicScrollPosition = 0;
    }, 'html')
}

function showMobileTOC() {
    topicScrollPosition = $window.scrollTop();
    document.getElementById('toc-wrapper').classList.remove('hidden');
    document.getElementById('article-wrapper').classList.add('hidden');
    document.getElementById('button-hide-show-toc').classList.remove('hidden');
    document.getElementById('button-expand-collapse').classList.remove('inactive');
    document.getElementById('button-show-active').classList.remove('inactive');
    document.getElementById('mobile-menu-button').classList.add('active');
    document.getElementsByClassName('left-buttons-container')[0].classList.remove('non-displayed');
    document.getElementsByClassName('right-buttons-container')[0].classList.add('non-displayed');
    document.getElementsByClassName('shading-container-wrapper')[0].classList.add('toc');
    $('.main-button-container-wrapper').css("margin", "auto");
    $('.rocks-header').hide();
    $('.breadcrumb-container').hide();
    $('.top-nav-buttons-container-wrapper').hide();
    $window.scrollTop(0);

    // Close sticky search when mobile TOC is opened
    if ($('.topic-page-sticky-search-container').hasClass('expanded')) {
        $('.topic-page-sticky-search-container').removeClass('expanded');
        $('.expand-collapse-search-container').removeClass('expanded');
    }
}

function hideMobileTOC() {
    document.getElementById('toc-wrapper').classList.add('hidden');
    document.getElementById('article-wrapper').classList.remove('hidden');
    document.getElementById('button-hide-show-toc').classList.add('hidden');
    document.getElementById('button-expand-collapse').classList.add('inactive');
    document.getElementById('button-show-active').classList.add('inactive');
    document.getElementById('mobile-menu-button').classList.remove('active');
    document.getElementsByClassName('left-buttons-container')[0].classList.add('non-displayed');
    document.getElementsByClassName('right-buttons-container')[0].classList.remove('non-displayed');
    document.getElementsByClassName('shading-container-wrapper')[0].classList.remove('toc');
    $('.main-button-container-wrapper').css("margin", "15px auto");
    $('.rocks-header').show();
    $('.breadcrumb-container').show();
    $('.top-nav-buttons-container-wrapper').show();
    $window.scrollTop(topicScrollPosition);
}

// Adding class for mobile breadcrumbs
function showBreadcrumbs(button) {
    document.getElementsByClassName('head-breadcrumbs-child-elements')[0].classList.toggle('show');
    $('.head-breadcrumbs-child-elements').children().toggleClass('show');

    if (($('.head-breadcrumbs-child-elements').hasClass('show'))) {
        document.getElementsByClassName('shading-container-wrapper')[0].classList.add('grey');
    }
}

window.onclick = function (event) {
    // Close the mobile breadcrumbs if the user clicks outside block
    if (!event.target.closest('.child-elements') && !event.target.matches('.three-dots-separator')) {
        closeBreadcrumbsPopUp();
    }

    // Close the dropdown menu from the download button if user clicks outside
    if (!event.target.matches('.button-dropdown-download') && !event.target.matches('#menu-dropdown-download')) {
        closeDropDown('.dropdown-content-download');
    }

    // Close the dropdown menu from the Google Drive dropdown if user clicks outside
    if (!event.target.matches('.button-dropdown-share-google-drive') && !event.target.matches('#menu-dropdown-google-drive')) {
        closeDropDown('.dropdown-content-google-drive');
    }
};

function closeBreadcrumbsPopUp(){
    if ($('.head-breadcrumbs-child-elements').hasClass('show')) {
        document.getElementsByClassName('head-breadcrumbs-child-elements')[0].classList.remove('show');
        $('.head-breadcrumbs-child-elements').children().removeClass('show');
        document.getElementsByClassName('shading-container-wrapper')[0].classList.remove('grey');
    }
}

function closeDropDown(className){
    if ($(className).hasClass('show')) {
        $(className).removeClass('show');
    }
}
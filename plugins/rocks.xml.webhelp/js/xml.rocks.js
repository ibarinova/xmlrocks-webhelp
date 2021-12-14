var backToTopButton = document.getElementById("button-back-to-top"),
    state = null;

window.onscroll = function () {
    scrollFunction();
};

function scrollFunction() {
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

$('div.toc-container nav li a').click(function(event) {
    event.preventDefault();
});

//Dynamically update page from the breadcrumbs links
$('body').on('click', '.head-breadcrumb a.link', function (event) {
    var currentHref = $(this).attr('href');

    event.preventDefault();

    window.history.pushState(currentHref, "", currentHref);

    reloadDynamically(currentHref);
});

//Dynamically update page from the nav buttons links
$('body').on('click', '.top-nav-buttons-container a', function (event) {
    var currentHref = $(this).attr('href');

    event.preventDefault();

    window.history.pushState(currentHref, "", currentHref);

    reloadDynamically(currentHref);
    showActive();
});

$('body').on('click', '.bottom-nav-buttons-container a', function (event) {
    var currentHref = $(this).attr('href');

    event.preventDefault();

    window.history.pushState(currentHref, "", currentHref);

    reloadDynamically(currentHref);
    showActive();
});

// Dynamically update parts of a web page, without reloading the whole page.
function getDynamicTopicData(href) {
    switch (window.location.protocol) {
        case 'file:':
            // go to href if HTML is opened as file:
            window.location = href;
            break;
        default:
            // update address bar
            window.history.pushState(href, "", href);

            reloadDynamically(href);
    }
}

// Expand topics in the TOC
function applyExpandedClass(id){
    if ($(id).parent().parent().hasClass('expanded')) {
        // remove .expanded from current TOC topic
        $(id).parent().parent().removeClass('expanded');

    } else {
        // add .expanded to current TOC topic
        $(id).parent().parent().addClass('expanded');
    }
}

// This function reveals active topic in the TOC when page reloads
$(document).ready(function() {
    // expand all parent li's
    $('.active').parents('nav li').addClass('expanded ancestor-of-active');

    var height = $(window).height() - ($("header").outerHeight() + $('div.breadcrumb-container').outerHeight() + $('div.top-nav-buttons-container-wrapper').outerHeight() + $('div.main-button-container').outerHeight() + $("footer").outerHeight() + 150);
    $("main.container").css("min-height", height+"px");

    window.addEventListener('popstate', function(event) {
        state = event.state;
        if(state != null && state != "null"){
            reloadDynamically(state);
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
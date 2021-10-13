//Get the button
var backToTopButton = document.getElementById("button-back-to-top");

// When the user scrolls down 20px from the top of the document, show the button
window.onscroll = function () {
    scrollFunction();
};

function scrollFunction() {
    if (
        document.body.scrollTop > 20 ||
        document.documentElement.scrollTop > 20
    ) {
        backToTopButton.style.display = "block";
    } else {
        backToTopButton.style.display = "none";
    }
}

// When the user clicks on the button, scroll to the top of the document
backToTopButton.addEventListener("click", backToTop);

function backToTop() {
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
}

//Create PDF from HTML...
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

// Function for download output file in PDF format from local output folder
function DownloadFile(fileName) {
    //Set the File URL.
    var url = "pdf/" + fileName;
    //Create XMLHTTP Request.
    var req = new XMLHttpRequest();
    req.open("GET", url, true);
    req.responseType = "blob";
    req.onload = function () {
        //Convert the Byte Data to BLOB object.
        var blob = new Blob([req.response], {type: "application/octetstream"});

        //Check the Browser type and download the File.
        var isIE = false || !!document.documentMode;
        if (isIE) {
            window.navigator.msSaveBlob(blob, fileName);
        } else {
            var url = window.URL || window.webkitURL;
            link = url.createObjectURL(blob);
            var a = document.createElement("a");
            a.setAttribute("download", fileName);
            a.setAttribute("href", link);
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        }
    };
    req.send();
};

// Function for dropdown menu for 'download' button
function dropdownDownload() {
    document.getElementById("menu-dropdown-download").classList.toggle("show");
}

// Close the dropdown menu if the user clicks outside of it
window.onclick = function (event) {
    if (!event.target.matches('.drop-button-download')) {
        var dropdowns = document.getElementsByClassName("dropdown-content-download");
        var i;
        for (i = 0; i < dropdowns.length; i++) {
            var openDropdown = dropdowns[i];
            if (openDropdown.classList.contains('show')) {
                openDropdown.classList.remove('show');
            }
        }
    }
};

// Function for dropdown menu for 'save to Google Drive' button
function dropdownGoogleDrive() {
    document.getElementById("menu-dropdown-google-drive").classList.toggle("show");
}

// Close the dropdown menu if the user clicks outside of it
window.onclick = function (event) {
    if (!event.target.matches('.drop-button-google-drive')) {
        var dropdowns = document.getElementsByClassName("dropdown-content-google-drive");
        var i;
        for (i = 0; i < dropdowns.length; i++) {
            var openDropdown = dropdowns[i];
            if (openDropdown.classList.contains('show')) {
                openDropdown.classList.remove('show');
            }
        }
    }
};

// The function dynamically updates parts of a web page, without reloading the whole page.
function getDynamicTopicData(href, listItemID) {
    switch (window.location.protocol) {
        case 'file:':
            // go to href if HTML is opened as file:
            window.location = href;
            break;
        default:
            // update required elements if HTML is opened on server
            jQuery.post(href, function (content) {
                var htmlContent = $.parseHTML(content),
                    articleContent = $(htmlContent).find('article').contents(),
                    breadcrumbsContent = $(htmlContent).find('.breadcrumb').contents(),
                    titleContent = $(htmlContent).filter('title').contents();

                // update address bar
                history.pushState("", "", href);

                // update head title
                $('title').html(titleContent);

                // update breadcrumbs
                $('.breadcrumb').html(breadcrumbsContent);

                // update article
                $('article').html(articleContent);

                // reset .active
                $('.toc-container').find('.active').removeClass('active');

                // add .active to recent TOC li
                $('.toc-container').find(listItemID).addClass('active');
            }, 'html')
    }
}

// This function expands topics in TOC
function applyExpandedClass(id){
    if ($(id).parent().hasClass('expanded')) {
        // remove .expanded from current TOC topic
        $(id).parent().removeClass('expanded');

        // change symbol to +
        $(id).html('+ ');
    } else {
        // add .expanded to current TOC topic
        $(id).parent().addClass('expanded');

        // change symbol to -
        $(id).html('- ');

        // remove .expanded for all siblings
        $(id).parent().siblings().removeClass('expanded');

        // remove .expanded for all descendants of siblings
        $(id).parent().siblings().find('.expand-collapse-button').parent().removeClass('expanded');

        // change - to + for all closed siblings
        $(id).parent().siblings().find('.expand-collapse-button').html('+ ');
    }
}

// This function reveals active topic in TOC when the page reloads
$(document).ready(function() {
    // expand all parent li's
    $('.active').parents('nav li').addClass('expanded');

    // update expanded symbol
    $('.active').parents('nav li').children('.expand-collapse-button').html('- ');
});
//Get the button
let mybutton = document.getElementById("btn-back-to-top");

// When the user scrolls down 20px from the top of the document, show the button
window.onscroll = function () {
    scrollFunction();
};

function scrollFunction() {
    if (
        document.body.scrollTop > 20 ||
        document.documentElement.scrollTop > 20
    ) {
        mybutton.style.display = "block";
    } else {
        mybutton.style.display = "none";
    }
}

// When the user clicks on the button, scroll to the top of the document
mybutton.addEventListener("click", backToTop);

function backToTop() {
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
}

function goBack() {
    window.history.back();
}

//Create PDF from HTML...
function getPDF() {
    console.log('in get pdf')
    var HTML_Width = $("#topic-article").width();
    var HTML_Height = $("#topic-article").height();
    var top_left_margin = 15;
    var PDF_Width = HTML_Width + (top_left_margin * 2);
    var PDF_Height = (PDF_Width * 1.5) + (top_left_margin * 2);
    var canvas_image_width = HTML_Width;
    var canvas_image_height = HTML_Height;

    var totalPDFPages = Math.ceil(HTML_Height / PDF_Height) - 1;


    html2canvas($("#topic-article")[0], {allowTaint: true}).then(function (canvas) {
        canvas.getContext('2d');

        console.log(canvas.height + "  " + canvas.width);


        var imgData = canvas.toDataURL("image/jpeg", 1.0);
        var pdf = new jsPDF('p', 'pt', [PDF_Width, PDF_Height]);
        pdf.addImage(imgData, 'JPG', top_left_margin, top_left_margin, canvas_image_width, canvas_image_height);


        for (var i = 1; i <= totalPDFPages; i++) {
            pdf.addPage(PDF_Width, PDF_Height);
            pdf.addImage(imgData, 'JPG', top_left_margin, -(PDF_Height * i) + (top_left_margin * 4), canvas_image_width, canvas_image_height);
        }

        pdf.save("HTML-Document.pdf");
    });
};

// Function for download pdf from output
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

// Function for dropdown menu
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

// Function for dropdown menu
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

// Function for print <article> content
function printDiv(divName) {
    var printContents = document.getElementById(divName).innerHTML;
    w = window.open();
    w.document.write(printContents);
    w.print();
    w.close();
}

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
                    breadcrumbsContent = $(htmlContent).find('.breadcrumb').contents();

                // update address bar
                history.pushState("", "", href);

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
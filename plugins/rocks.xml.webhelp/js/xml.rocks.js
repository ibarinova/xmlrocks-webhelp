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

function getArticleElement(href) {
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
            }, 'html')
    }
}
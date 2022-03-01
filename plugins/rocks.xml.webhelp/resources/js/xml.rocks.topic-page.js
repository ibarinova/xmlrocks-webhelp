$(document).ready(function() {
    // When page reloads stick main-button-container to the top if needed
    if (($window.scrollTop() >= $('.main-button-container-wrapper').offset().top) && $('.main-button-container-wrapper')) {
        document.getElementsByClassName('main-button-container-wrapper')[0].classList.add('is-sticky');
    }

    // Hide TOC on mobile page
    if(($window.width() < 1170) && (!($('#toc-wrapper').hasClass('hidden')))) {
        document.getElementById('toc-wrapper').classList.add('hidden');
        document.getElementById('button-hide-show-toc').classList.add('hidden');
        document.getElementById('button-expand-collapse').classList.add('hidden');
        document.getElementById('button-show-active').classList.add('hidden');
        document.getElementsByClassName('left-buttons-container')[0].classList.add('non-displayed');
    }

    // Press sticky search button on enter
        // Get the input field
        var stickyInput = document.getElementById("sticky-search-input");

        // Execute a function when the user releases a key on a keyboard
        stickyInput.addEventListener("keyup", function(event) {
            // Number 13 is the "Enter" key on a keyboard
            if (event.keyCode === 13) {
                // Trigger the button element with a click
                document.getElementById("sticky-search-button").click();
            }
        });
});

// Hide TOC on mobile page
$window.on('resize', function() {
    if(($window.width() < 1170) && ($window.width() !== previousWidth) && (!($('#toc-wrapper').hasClass('hidden')))) {
        document.getElementById('toc-wrapper').classList.add('hidden');
        document.getElementById('button-hide-show-toc').classList.add('hidden');
        document.getElementById('button-expand-collapse').classList.add('inactive');
        document.getElementById('button-show-active').classList.add('inactive');
        document.getElementById('mobile-menu-button').classList.remove('active');
        document.getElementsByClassName('left-buttons-container')[0].classList.add('non-displayed');
    } else if(($window.width() < 1170)) {
        document.getElementsByClassName('left-buttons-container')[0].classList.add('non-displayed');
        document.getElementsByClassName('right-buttons-container')[0].classList.remove('non-displayed');
    } else {
        document.getElementsByClassName('left-buttons-container')[0].classList.remove('non-displayed');
        document.getElementsByClassName('right-buttons-container')[0].classList.remove('non-displayed');
        document.getElementsByClassName('shading-container-wrapper')[0].classList.remove('toc');
        closeBreadcrumbsPopUp();
    }
});
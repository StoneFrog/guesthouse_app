$(function () {
// Scroll to function
  function scrollTo(ele) {
    $("html, body").animate({
        scrollTop: ($(ele).offset().top - $("header").outerHeight(true))
    });
  }

// Detect location hash
  if (window.location.hash) {
    scrollTo(window.location.hash);
  }

// Detect urlchange
  $(window).on('hashchange', function(e) {
    scrollTo(window.location.hash);
    e.preventDefault();
  });
});
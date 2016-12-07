$(document).ready(function() {

  $(window).scroll(function () {
    if ($(window).scrollTop() > 65) {
      $('#search-bar-index').addClass('search-bar-index-fixed');
    }
    if ($(window).scrollTop() < 65) {
      $('#search-bar-index').removeClass('search-bar-index-fixed');
    }
  });
});

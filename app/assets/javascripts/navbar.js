$(document).ready(function() {

  $(window).scroll(function () {
    if ($(window).scrollTop() > 150) {
      $('#navbar-bottom').addClass('navbar-fixed');
    }
    if ($(window).scrollTop() < 150) {
      $('#navbar-bottom').removeClass('navbar-fixed');
    }
  });
});

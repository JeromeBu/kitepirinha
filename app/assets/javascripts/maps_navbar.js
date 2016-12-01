$(window).scroll(function () {
  // $('.width_box').css('top', '115px')

  if ($(window).scrollTop() < 65) {
    var topPage = $(window).scrollTop();
    var setTop = 115 - topPage;
    $('.width_box').css('top', setTop + 'px')
    $('#map').css('height', 'calc(100vh - 115px')
  }
  if ($(window).scrollTop() > 65) {
    $('.width_box').css('top', '50px')
    $('#map').css('height', 'calc(100vh - 50px')
  }
  });


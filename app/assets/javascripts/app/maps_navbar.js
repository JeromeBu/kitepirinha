$(window).scroll(function () {
  // $('.width_box').css('top', '115px')

  if ($(window).scrollTop() < 80) {
    var topPage = $(window).scrollTop();
    var setTop = 135 - topPage;
    $('.width_box').css('top', setTop + 'px')
    $('#map').css('height', 'calc(100vh - 135px')
  }
  if ($(window).scrollTop() > 80) {
    $('.width_box').css('top', '55px')
    $('#map').css('height', 'calc(100vh - 55px')
  }
  });


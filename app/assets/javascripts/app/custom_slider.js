

$(function() {
  $('.slider').bootstrapSlider();
  $('.wing-size-feedback-slider').bootstrapSlider('setValue', 11);
  $("div.slider").css("opacity", 0);
  $('#weather-feedbacks-modal').on('shown.bs.modal', function () {
    $(".wing-size-feedback-slider").prev().addClass("wing-size-feedback-slider-left-margin");
    $("input.slider").bootstrapSlider('refresh');
    $("div.slider").css("opacity", 1);

    $(".wing-releavance-feedback-slider").prev().addClass("wing-size-feedback-slider-left-margin");

  })

});


$(function() {
  $('.slider').bootstrapSlider();
  $("div.slider").css("opacity", 0);
  $('#weather-feedbacks-modal').on('shown.bs.modal', function () {
    $(".wing-size-feedback-slider").prev().addClass("wing-size-feedback-slider-left-margin");
    $("input.slider").bootstrapSlider('refresh');
    $("div.slider").css("opacity", 1);

    $("input.slider.wing-size-feedback-slider").bootstrapSlider('refresh').on('slide', function(ev) {
      var slider_value = $(this).bootstrapSlider('getValue');
      $("#wing_size").attr('value', slider_value);
    });

    $("input.slider.wing-releavance-feedback-slider").bootstrapSlider('refresh').on('slide', function(ev) {
      var slider_value = $(this).bootstrapSlider('getValue');
      $("#wing_size_exp_rating").attr('value', slider_value);
    });

    $(".wing-releavance-feedback-slider").prev().addClass("wing-size-feedback-slider-left-margin");

  })

});

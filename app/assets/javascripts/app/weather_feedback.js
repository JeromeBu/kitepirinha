$(function() {
  $("#picker").anglepicker({

      start: function(e, ui) {

      },
      change: function(e, ui) {
          var rotated_angle = 0;
          if (ui.value >= 270) {
            rotated_angle = ui.value - 270;
          }
          else {
            rotated_angle = ui.value + 90;
          }
          $("#wind_measured_angle").attr('value', rotated_angle);
          $("p#current_value_degrees").text(rotated_angle + '°')
      },
      stop: function(e, ui) {

      },

      //  {
      //   distance: 1,
      //   delay: 1,
      //   snap: 1,
      //   min: 0,
      //   shiftSnap: 15,
      //   value: 90,
      //   clockwise: true
      // }

    });

    // $("#weather_feedback_direction").anglepicker({
    //   value: 90,
    //   clockwise: true,
    // });
    $('#add-feedback-modal-button').on('click', function(event){
      $('#weather-feedbacks-modal').modal('hide');
    });

});

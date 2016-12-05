$(function() {
  $("#picker").anglepicker({

      start: function(e, ui) {

      },
      change: function(e, ui) {
          $("#weather_feedback_direction").val(ui.value)
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


});

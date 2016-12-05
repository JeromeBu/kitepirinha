$( "#tab_weather" ).click(function() {
  event.preventDefault();
  $( "#tab_weather" ).addClass ("active");
  $( "#tab_infos" ).removeClass ("active");
  $( "#tab_reviews" ).removeClass ("active");
  $( "#content_for_weather" ).removeClass ("hidden");
  $( "#content_for_infos" ).addClass ("hidden");
  $( "#content_for_reviews" ).addClass ("hidden");
});

$( "#tab_infos" ).click(function() {
  event.preventDefault();
  $( "#tab_weather" ).removeClass ("active");
  $( "#tab_infos" ).addClass ("active");
  $( "#tab_reviews" ).removeClass ("active");
  $( "#content_for_weather" ).addClass ("hidden");
  $( "#content_for_infos" ).removeClass ("hidden");
  $( "#content_for_reviews" ).addClass ("hidden");
});

$( "#tab_reviews" ).click(function() {
  event.preventDefault();
  $( "#tab_weather" ).removeClass ("active");
  $( "#tab_infos" ).removeClass ("active");
  $( "#tab_reviews" ).addClass ("active");
  $( "#content_for_weather" ).addClass ("hidden");
  $( "#content_for_infos" ).addClass ("hidden");
  $( "#content_for_reviews" ).removeClass ("hidden");
});

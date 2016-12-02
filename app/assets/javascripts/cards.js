$( ".spot-card" )
  .mouseover(function() {
    $(this).children(".spot-infos").removeClass('small').addClass('full');
  })
  .mouseout(function() {
     $(this).children(".spot-infos").removeClass('full').addClass('small');
  });

$( ".spot-card" )
  .mouseover(function() {
    $(this).find(".spot-full-infos").show();
  })
  .mouseout(function() {
     $(this).find(".spot-full-infos").hide();
  });

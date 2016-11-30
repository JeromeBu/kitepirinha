$( ".spot-card" )
  .mouseover(function() {
    $(this).children(".spot-infos").removeClass('small').addClass('full');
    console.log("toto")
  })
  .mouseout(function() {
     $(this).children(".spot-infos").removeClass('full').addClass('small');
     console.log("tata")
  });

$( ".spot-card" )
  .mouseover(function() {
    $(this).find(".spot-full-infos").show();
    console.log("titi")
  })
  .mouseout(function() {
     $(this).find(".spot-full-infos").hide();
     console.log("tata")
  });

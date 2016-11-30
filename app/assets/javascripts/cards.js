$( ".spot-card" )
  .mouseover(function() {
    $(this).children(".spot-infos").removeClass('small').addClass('full');
    console.log("toto")
  })
  .mouseout(function() {
     $(this).children(".spot-infos").removeClass('full').addClass('small');
     console.log("tata")
  });

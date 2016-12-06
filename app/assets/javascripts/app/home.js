  $('#first-button').on('click', function(event) {
    event.preventDefault();
    $('#first-button').toggleClass('hidden');
    $('#second-button').toggleClass('hidden');
    $('#main-title').toggleClass('hidden');
    $('#search').toggleClass('hidden');
    $('.wing_size').toggleClass('hidden');
    $('.home_sea').toggleClass('hidden');
  });

  $('#first-button').on('click', function(event) {
    event.preventDefault();

    $('#first-button').toggleClass('hidden');

    $('#main-title').toggleClass('hidden');
    $('.search_address_box').toggleClass('hidden');

    $('.home_sea').toggleClass('hidden');
  });

  $('#arrow').on('click', function(event) {
    $('.wing_size').toggleClass('hidden');
    $('#second-button').toggleClass('hidden');
  });

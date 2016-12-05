$('.kite-home-btn').on('click', function(event) {
    event.preventDefault(1);
  $('#main-title').toggleClass('hidden');
  $('#search').toggleClass('hidden');
  $('.wing_size').toggleClass('hidden');
  $('.home_sea').toggleClass('hidden');
});

$('#first-button').on('click', function(event) {
  event.preventDefault();

  $('#first-button').toggleClass('hidden');

  $('#main-title').toggleClass('hidden');
  $('.search_address_box').toggleClass('hidden');

  $('.home_sea').toggleClass('hidden');
});

$('#arrow').on('click', function(event) {
  $('.wing_size').toggleClass('hidden');
  setTimeout(function (){
    $('.wing_size').toggleClass('active');
  }, 10);
  setTimeout(function (){
    $('#arrow').toggleClass('pointer-disable');
  }, 1);
});

var count = 0
$('input').keyup(function(event) {
  if (event.keyCode === 13) {
    if (count < 1) {
      count += 1;
      console.log(count)
      $('.wing_size').toggleClass('hidden');
      setTimeout(function (){
        $('.wing_size').toggleClass('active');
      }, 10);
      setTimeout(function (){
        $('#arrow').toggleClass('pointer-disable');
      }, 1);
    } if (count > 1) {
      console.log("hello")
    }
  }
});

// http://shoptalkshow.com/episodes/134-marc-grabanski/#t=16:07

// vanilla JS
function toggleButton(el) {
  var body = document.body;
  var element = document.querySelector(el);
  element.addEventListener('mouseenter', function(e) {
    e.target.classList.add('active');
    body.classList.add('blur');
  }, false);
  element.addEventListener('mouseleave', function(e) {
    e.target.classList.remove('active');
    body.classList.remove('blur');
  }, false);
};

//toggleButton('[data-js="btn"]');

// jQuery
/*
$('[data-js="btn"]').hover(function(){
  $(this).toggleClass('active');
  if ($(this).hasClass('active')) {
    $('body').addClass('blur');
  } else {
    $('body').removeClass('blur');
  }
});
*/

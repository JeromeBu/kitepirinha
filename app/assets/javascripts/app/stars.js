$(function() {

  // $('#radio4').on('click', function() {
  //   //$('#review-rating').attr('value', 4);
  //   console.log('radio 4');
  // });

  $('.classification .fa').on('click', function() {
    var rating = $(this).parent().attr('for').slice(-1);
    $('#review_rating').attr('value', rating);
  });

});

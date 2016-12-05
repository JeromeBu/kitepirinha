    $(document).ready(function() {

      var data_div = $('iframe').contents().find("#data-container");
      $('iframe').remove();
      $('.tide-data').append(data_div);;
      $('.tide-data > script').remove();
      $('#data-container > h2').remove();
      $('.tide-data').removeClass('hidden');
      $('.tide-data table').addClass('table');


    });

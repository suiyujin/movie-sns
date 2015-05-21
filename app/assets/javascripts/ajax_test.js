$(document).ready(function(){
  $('form#form-ajax').bind("ajax:success", function(evt, data, status, xhr){
    $res_json = data;
    console.log(data)
    $('#result-form').append(xhr.responseText);
  })
});

$(document).ready(function(){
  $('a#link-ajax').bind("ajax:success", function(evt, data, status, xhr){
    $res_json = data;
    console.log(data)
    $('#result-link').append(data);
  })
});

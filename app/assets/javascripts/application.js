// This is a manifest file that"ll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin"s vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It"s not advisable to add code directly here, but if you do, it"ll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

function add_fields(link, assoc, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + assoc, "g")
  $(link).before(content.replace(regexp, new_id));
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".form-group").hide();
}

setTimeout(function() {
  $('.flash').fadeOut();}, '5000'
);

$(document).ready(function () {
  var timeleft = $("#timeleft").data("time");
  function countdown_timer(){
    if (timeleft < 0){
      clearInterval(counter); 
      if ($("#exam_submit").length == 1) {
        $("#exam_submit").click();
        alert("Time expired!\nYour answers were auto submitted.");
      }
      timeleft = 0;
    }

    minute = parseInt(timeleft / 60);
    second = timeleft % 60 ;
    $("#timeleft").html("Time left: " + minute + " m : " + second + " s.");
    timeleft = timeleft - 1;
  } 
  if (timeleft != null){
    var minute, second;
    var counter = setInterval(countdown_timer, 1000);
  }
  return;    
});

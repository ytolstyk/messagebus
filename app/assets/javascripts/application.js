// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require Chart
//= require_tree .

$(function() {
  var $today = $("#today");
  var $threeDays = $("#three-days");
  var $sevenDays = $("#seven-days");
  var $fourteenDays = $("#fourteen-days");

  var $all = $(".segment-all");
  var $male = $(".segment-male");
  var $female = $(".segment-female");

  // var data = {
  //   labels : ["January","February","March","April","May","June","July"],
  //   labels : ["","","","","","",""],
  //   datasets : [
  //     {
  //       fillColor : "rgba(151,187,205,0.5)",
  //       strokeColor : "rgba(151,187,205,1)",
  //       pointColor : "rgba(151,187,205,1)",
  //       pointStrokeColor : "#fff",
  //       data : [28,48,40,19,96,27,100]
  //     }
  //   ]
  // };

  $today.on("click", todayChart);
  $threeDays.on("click", threeDaysChart);
  $sevenDays.on("click", sevenDaysChart);
  $fourteenDays.on("click", fourteenDaysChart);

  function todayChart(event) {
    event.preventDefault();
    makeRequest("devices/today");
  };

  function threeDaysChart(event) {
    event.preventDefault();
    makeRequest("devices/three");
  };

  function sevenDaysChart(event) {
    event.preventDefault();
    makeRequest("devices/seven");
  };

  function fourteenDaysChart(event) {
    event.preventDefault();
    makeRequest("devices/fourteen");
  };

  function makeRequest(path) {
    $.ajax({
      url: path,
      method: "GET",
      dataType: "json",
      data: {},
      success: function(data) {
        populateChart(data);
        updateNumbers(data);
      }
    });
  };

  function populateChart(data) {
    $('.chart').replaceWith('<canvas class="chart" width="800" height="300"></canvas>');
    var ctx = $(".chart").get(0).getContext("2d");
    new Chart(ctx).Line(data);
  };

  function updateNumbers(data) {
    $all.text(data.segments.all);
    $male.text(data.segments.male);
    $female.text(data.segments.female);
  };

});
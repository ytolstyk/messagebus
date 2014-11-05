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

  var $allLink = $("#all-link");
  var $maleLink = $("#male-link");
  var $femaleLink = $("#female-link");

  var $meanLine = $("#mean-line");
  var $trendLine = $("#trend-line");

  var chartData = {}

  $today.on("click", todayChart);
  $threeDays.on("click", threeDaysChart);
  $sevenDays.on("click", sevenDaysChart);
  $fourteenDays.on("click", fourteenDaysChart);

  $allLink.on("click", normalChart);
  $maleLink.on("click", displayMale);
  $femaleLink.on("click", displayFemale);

  $meanLine.on("click", meanChart);
  $trendLine.on("click", trendChart);

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
        chartData = data;
        populateChart(data);
        populatePieChart(data);
        updateNumbers(data);
      }
    });
  };

  function populatePieChart(data) {
    $('.pie-chart').replaceWith('<canvas class="pie-chart" width="300" height="300"></canvas>');
    var ctx = $(".pie-chart").get(0).getContext("2d");
    new Chart(ctx).Pie(data.device_data);
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

  function normalChart() {
    clearChart();

    populateChart(chartData);
  };

  function displayMale() {
    clearChart();
    chartData.datasets.push(chartData.male_data);

    populateChart(chartData);    
  };

  function displayFemale() {
    clearChart();
    chartData.datasets.push(chartData.female_data);

    populateChart(chartData);
  };

  function meanChart(event) {
    event.preventDefault();
    clearChart();
    var len = chartData.datasets[0].length;
  };

  function trendChart(event) {
    event.preventDefault();
    clearChart();
    var len = chartData.datasets[0].length;
  };

  function clearChart() {
    if (chartData.datasets.length > 1) {
      chartData.datasets = [chartData.datasets[0]];
    }
  };

  $fourteenDays.trigger("click");
});
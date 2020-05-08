// Dashboard - Modern
//----------------------

(function (window, document, $) {

  //Income chart

  // Options
  var SLOption = {
      responsive: true,
      maintainAspectRatio: true,
      datasetStrokeWidth: 3,
      pointDotStrokeWidth: 4,
      tooltipFillColor: "rgba(0,0,0,0.6)",
      tooltips: {
          callbacks: {
              label: function (tooltipItem, data) {
                  return '$' + tooltipItem.yLabel.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
              }
          }
      },
      legend: {
          display: false,
          position: "bottom"
      },
      hover: {
          mode: "label"
      },
      scales: {
          xAxes: [
              {
                  display: false
              }
          ],
          yAxes: [
              {
                  display: false
              }
          ]
      },
      title: {
          display: false,
          fontColor: "#FFF",
          fullWidth: false,
          fontSize: 40,
          text: "82%"
      }
  }
  var SLlabels = ["January", "February", "March", "April", "May", "June"]

  var LineSL3ctx = document
      .getElementById("income-dashboard-chart")
      .getContext("2d")

  var gradientStroke = LineSL3ctx.createLinearGradient(500, 0, 0, 200)
  gradientStroke.addColorStop(0, "#3f51b5")

  var gradientFill = LineSL3ctx.createLinearGradient(500, 0, 0, 200)
  gradientFill.addColorStop(0, "#2196f3")
  gradientFill.addColorStop(1, "#4a148c")

  var SL3Chart = new Chart(LineSL3ctx, {
      type: "line",
      data: {
          labels: SLlabels,
          datasets: [
              {
                  // label: "My Second dataset",
                  borderColor: gradientStroke,
                  pointColor: "#fff",
                  pointBorderColor: gradientStroke,
                  pointBackgroundColor: "#fff",
                  pointHoverBackgroundColor: gradientStroke,
                  pointHoverBorderColor: gradientStroke,
                  pointRadius: 4,
                  pointBorderWidth: 1,
                  pointHoverRadius: 4,
                  pointHoverBorderWidth: 1,
                  fill: true,
                  backgroundColor: gradientFill,
                  borderWidth: 2,
                  data: [24, 18, 20, 30, 40, 43]
              }
          ]
      },
      options: SLOption
  })

  //Expenses chart

  // Options
  var SLOption = {
      responsive: true,
      maintainAspectRatio: true,
      datasetStrokeWidth: 3,
      pointDotStrokeWidth: 4,
      tooltipFillColor: "rgba(0,0,0,0.6)",
      tooltips: {
          callbacks: {
              label: function (tooltipItem, data) {
                  return '$' + tooltipItem.yLabel.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
              }
          }
      },
      legend: {
          display: false,
          position: "bottom"
      },
      hover: {
          mode: "label"
      },
      scales: {
          xAxes: [
              {
                  display: false
              }
          ],
          yAxes: [
              {
                  display: false
              }
          ]
      },
      title: {
          display: false,
          fontColor: "#FFF",
          fullWidth: false,
          fontSize: 40,
          text: "82%"
      }
  }
  var SLlabels = ["January", "February", "March", "April", "May", "June"]

  var LineSL3ctx = document
      .getElementById("expenses-dashboard-chart")
      .getContext("2d")

  var gradientStroke = LineSL3ctx.createLinearGradient(500, 0, 0, 200)
  gradientStroke.addColorStop(0, "#F44336")

  var gradientFill = LineSL3ctx.createLinearGradient(500, 0, 0, 200)
  gradientFill.addColorStop(0, "#f44336")
  gradientFill.addColorStop(1, "#b71c1c")

  var SL3Chart = new Chart(LineSL3ctx, {
      type: "line",
      data: {
          labels: SLlabels,
          datasets: [
              {
                  // label: "My Second dataset",
                  borderColor: gradientStroke,
                  pointColor: "#fff",
                  pointBorderColor: gradientStroke,
                  pointBackgroundColor: "#fff",
                  pointHoverBackgroundColor: gradientStroke,
                  pointHoverBorderColor: gradientStroke,
                  pointRadius: 4,
                  pointBorderWidth: 1,
                  pointHoverRadius: 4,
                  pointHoverBorderWidth: 1,
                  fill: true,
                  backgroundColor: gradientFill,
                  borderWidth: 1,
                  data: [55, 300, 250, 150, 280, 170]
              }
          ]
      },
      options: SLOption
  })

  //Balance chart

  // Options
  var SLOption = {
      currency: "$",
      responsive: true,
      maintainAspectRatio: true,
      datasetStrokeWidth: 3,
      pointDotStrokeWidth: 4,
      tooltipFillColor: "rgba(0,0,0,0.6)",
      tooltips: {
          callbacks: {
              label: function (tooltipItem, data) {
                  return '$' + tooltipItem.yLabel.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
              }
          }
      },
      legend: {
          display: false,
          position: "bottom"
      },
      hover: {
          mode: "label"
      },
      scales: {
          xAxes: [
              {
                  display: false
              }
          ],
          yAxes: [
              {
                  display: false
              }
          ]
      },
      title: {
          display: false,
          fontColor: "#FFF",
          fullWidth: false,
          fontSize: 40,
          text: "82%"
      }
  }
  var SLlabels = ["January", "February", "March", "April", "May", "June"]

  var LineSL3ctx = document
      .getElementById("balance-dashboard-chart")
      .getContext("2d")

  var gradientStroke = LineSL3ctx.createLinearGradient(500, 0, 0, 200)
  gradientStroke.addColorStop(0, "#4CAF50")

  var gradientFill = LineSL3ctx.createLinearGradient(500, 0, 0, 200)
  gradientFill.addColorStop(0, "#8bc34a")
  gradientFill.addColorStop(1, "#2e7d32")

  var SL3Chart = new Chart(LineSL3ctx, {
      type: "line",
      data: {
          labels: SLlabels,
          datasets: [
              {
                  // label: "My Second dataset",
                  borderColor: gradientStroke,
                  pointColor: "#fff",
                  pointBorderColor: gradientStroke,
                  pointBackgroundColor: "#fff",
                  pointHoverBackgroundColor: gradientStroke,
                  pointHoverBorderColor: gradientStroke,
                  pointRadius: 4,
                  pointBorderWidth: 1,
                  pointHoverRadius: 4,
                  pointHoverBorderWidth: 1,
                  fill: true,
                  backgroundColor: gradientFill,
                  borderWidth: 1,
                  data: [55000.56, 56000, 1020, 3050, 2000, 4003]
              }
          ]
      },
      options: SLOption,
      plugins: [
          Chartist.plugins.tooltip({
              currency: "$"
          })
      ]
  })

})(window, document, jQuery)
// line chart
var ctxL = document.getElementById("lineChart").getContext('2d');
var myLineChart = new Chart(ctxL, dataFunc());

function dataFunc() {
  return {
    type: 'line',
    data: {
      labels: data_labels, //defined in results-view
      datasets: [
        {
          label: "Precipitation",
          // Get from app
          data: p_data,  //defined in results-view
          backgroundColor: ['rgba(105, 0, 132, .2)',],
          borderColor: ['rgba(200, 99, 132, .7)',],
          borderWidth: 2},
        {
          label: "Discharge",
          // Get from app
          data: w_data, //defined in results-view
          backgroundColor: ['rgba(0, 137, 132, .2)',],
          borderColor: ['rgba(0, 10, 130, .7)',], 
          borderWidth: 2
        }
      ]
    },
    options: { 
      responsive: true
    }
  };
}

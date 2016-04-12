
width = 465
height = 500
var svg = dimple.newSvg("#cltvplot", width, height);
var data = [
		{ Year: 1, CLTV: 'Predicted', CLTVs: 0 },
		{ Year: 2, CLTV: 'Predicted', CLTVs: 0 },
		{ Year: 3, CLTV: 'Predicted', CLTVs: 0 },
		{ Year: 4, CLTV: 'Predicted', CLTVs: 0 },
		{ Year: 5, CLTV: 'Predicted', CLTVs: 0 },
		{ Year: 6, CLTV: 'Predicted', CLTVs: 0 },
		{ Year: 7, CLTV: 'Predicted', CLTVs: 2 },
		{ Year: 8, CLTV: 'Predicted', CLTVs: 0 },
		{ Year: 9, CLTV: 'Predicted', CLTVs: 0 },
   { Year: 10, CLTV: 'Predicted', CLTVs: 0 },
		{ Year: 1, CLTV: 'Test', CLTVs: 1 },
		{ Year: 2, CLTV: 'Test', CLTVs: 1 },
		{ Year: 3, CLTV: 'Test', CLTVs: 1 },
		{ Year: 4, CLTV: 'Test', CLTVs: 2 },
		{ Year: 5, CLTV: 'Test', CLTVs: 1 },
		{ Year: 6, CLTV: 'Test', CLTVs: 1 },
		{ Year: 7, CLTV: 'Test', CLTVs: 1 },
		{ Year: 8, CLTV: 'Test', CLTVs: 1 },
		{ Year: 9, CLTV: 'Test', CLTVs: 1 },
   { Year: 10, CLTV: 'Test', CLTVs: 1 }
];

var myChart = new dimple.chart(svg, data);
myChart.setBounds(50, 20, width-80, height-70)
var x = myChart.addCategoryAxis("x", "Year");
x.addOrderRule("Year");
myChart.addMeasureAxis("y", "CLTVs");
myChart.addSeries("CLTV", dimple.plot.line);

//myChart.addLegend(60, 10, 500, 20, "right");
myChart.draw();

Shiny.addCustomMessageHandler("CLTVhandler_2", function(CLTV){
	debugger;
	myChart.data = CLTV;
	myChart.draw(1000);
})

//<script src="http://d3js.org/d3.v3.min.js"></script>
//<script src="http://d3js.org/topojson.v1.min.js"></script>
//<script src="http://dimplejs.org/dist/dimple.v2.1.2.min.js"></script>

/* myChart.setBounds(60, 30, 510, 330)
myChart.addCategoryAxis("x", ["Price Tier", "Channel"]);
myChart.addMeasureAxis("y", "Unit Sales");
myChart.addSeries("Channel", dimple.plot.bar);
myChart.addLegend(65, 10, 510, 20, "right");
myChart.draw(); */

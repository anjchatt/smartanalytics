
width = 465
height = 500
var svg = dimple.newSvg("#barplot", width, height);
var data = [
		{ Segment: "# 1", Value: (Math.random() * 1000000), Type: "CP", Number: (Math.random() * 10000)},
		{ Segment: "# 2", Value: (Math.random() * 1000000), Type: "CP", Number: (Math.random() * 10000)},
		{ Segment: "# 3", Value: (Math.random() * 1000000), Type: "CP", Number: (Math.random() * 10000)},
		{ Segment: "# 4", Value: (Math.random() * 1000000), Type: "CP", Number: (Math.random() * 10000)},
		{ Segment: "# 5", Value: (Math.random() * 1000000), Type: "CP", Number: (Math.random() * 10000)}	
];

var myChart_bar = new dimple.chart(svg, data);
myChart_bar.setBounds(50, 20, width-80, height-70);
//x = myChart.addCategoryAxis("x", ["Segment", "Type"]);
//x.addGroupOrderRule(["CP", "CLTV"]);
myChart_bar.addCategoryAxis("x", "Segment");
myChart_bar.addMeasureAxis("y", "Value");
myChart_bar.addSeries("Type", dimple.plot.bar);
myChart_bar.addLegend(65, 10, width-100, 20, "right");
myChart_bar.assignColor("CLTV", "rgb(251, 128, 114)");
myChart_bar.assignColor("CP", "rgb(128, 177, 211)");
myChart_bar.draw();

Shiny.addCustomMessageHandler("CLTVhandler", function(value){
	debugger;
	myChart_bar.data = value;
	myChart_bar.draw(1000);
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

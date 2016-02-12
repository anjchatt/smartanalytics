<!doctype HTML>
<meta charset = 'utf-8'>
<html>
  <head>
    
    <script src='http://d3js.org/d3.v3.min.js' type='text/javascript'></script>
    <script src='http://d3js.org/topojson.v1.min.js' type='text/javascript'></script>
    <script src='http://datamaps.github.io/scripts/datamaps.all.min.js' type='text/javascript'></script>
   
    
    <style>
    .states {
      display: block;
      margin-left: auto; 
      margin-right: auto;
      width: 800px;
      height: 400px;
    }  
    #disqus_thread{
      padding-top: 100px;
    }
    </style>
    
  </head>
  <body >
    
    <div id = 'chartb9fd59e2efd0' class = 'states datamaps'></div>    
    <script id='popup-template' type='text/x-handlebars-template'>
    
</script>
<script>
  var chartParams = {
 "dom": "chartb9fd59e2efd0",
"width":    800,
"height":    350,
"scope": "usa",
"fills": {
"Positive": "#87D37C",
"Neutral": "#F5AB35",
"Negative": "#EF4836"
},
"legend": true,
"labels": true,
"data": {
 "AK": {
"State": "AK",
"fillKey": "Positive" 
},
"AL": {
"State": "AL",
"fillKey": "Neutral" 
},
"AR": {
"State": "AR",
"fillKey": "Neutral" 
},
"AZ": {
"State": "AZ",
"fillKey": "Neutral"  
},
"CA": {
"State": "CA",
"fillKey": "Negative" 
},
"CO": {
"State": "CO",
"fillKey": "Positive"
},
"CT": {
"State": "CT",
"fillKey": "Negative" 
},
"DE": {
"State": "DE",
"fillKey": "Positive" 
},
"FL": {
"State": "FL",
"fillKey": "Neutral" 
},
"GA": {
"State": "GA",
"fillKey": "Neutral" 
},
"HI": {
"State": "HI",
"fillKey": "Neutral" 
},
"IA": {
"State": "IA",
"fillKey": "Positive" 
},
"ID": {
"State": "ID",
"fillKey": "Negative" 
},
"IL": {
"State": "IL",
"fillKey": "Positive" 
},
"IN": {
"State": "IN",
"fillKey": "Positive" 
},
"KS": {
"State": "KS",
"fillKey": "Neutral" 
},
"KY": {
"State": "KY",
"fillKey": "Neutral" 
},
"LA": {
"State": "LA",
"fillKey": "Neutral" 
},
"MA": {
"State": "MA",
"fillKey": "Positive" 
},
"MD": {
"State": "MD",
"fillKey": "Positive" 
},
"ME": {
"State": "ME",
"fillKey": "Negative"
},
"MI": {
"State": "MI",
"fillKey": "Neutral" 
},
"MN": {
"State": "MN",
"fillKey": "Positive" 
},
"MO": {
"fillKey": "Neutral" 
},
"MS": {
"State": "MS",
"fillKey": "Positive" 
},
"MT": {
"State": "MT",
"fillKey": "Negative" 
},
"NC": {
"State": "NC",
"fillKey": "Neutral" 
},
"ND": {
"State": "ND",
"fillKey": "Negative" 
},
"NE": {
 
"State": "NE",
"fillKey": "Positive" 
},
"NH": {
"State": "NH",
"fillKey": "Negative" 
},
"NJ": {
"State": "NJ",
"fillKey": "Negative" 
},
"NM": {
"State": "NM",
"fillKey": "Neutral" 
},
"NV": {
"State": "NV",
"fillKey": "Neutral" 
},
"NY": {
"State": "NY",
"fillKey": "Negative" 
},
"OH": {
"State": "OH",
"fillKey": "Neutral" 
},
"OK": {
"State": "OK",
"fillKey": "Negative" 
},
"OR": {
"State": "OR",
"fillKey": "Positive" 
},
"PA": {
"State": "PA",
"fillKey": "Negative" 
},
"RI": {
"State": "RI",
"fillKey": "Positive" 
},
"SC": {
"State": "SC",
"fillKey": "Neutral" 
},
"SD": {
"State": "SD",
"fillKey": "Positive" 
},
"TN": {
"State": "TN",
"fillKey": "Neutral" 
},
"TX": {
"State": "TX",
"fillKey": "Negative" 
},
"UT": {
"State": "UT",
"fillKey": "Positive" 
},
"VA": {
"State": "VA",
"fillKey": "Negative" 
},
"VT": {
"State": "VT",
"fillKey": "Neutral" 
},
"WA": {
"State": "WA",
"fillKey": "Positive" 
},
"WI": {
"State": "WI",
"fillKey": "Positive" 
},
"WV": {
"State": "WV",
"fillKey": "Positive" 
},
"WY": {
"State": "WY",
"fillKey": "Neutral" 
} 
},
"geographyConfig": {
 "popupTemplate":  function(geography, data){
    return '<div class=hoverinfo><strong>' + geography.properties.name + '</strong></div>';
  }  
},
"id": "chartb9fd59e2efd0" 
}
  chartParams.element = document.getElementById('chartb9fd59e2efd0')
  
  
  var mapchartb9fd59e2efd0 = new Datamap(chartParams);
  
  if (chartParams.bubbles) {
    var bubbles = chartParams.bubbles
    mapchartb9fd59e2efd0.bubbles(bubbles)
  }
  
  if (chartParams.labels){
    mapchartb9fd59e2efd0.labels()
  }
  
  if (chartParams.legend){
    mapchartb9fd59e2efd0.legend()
  }
  
  setProjection = function( element, options ) {
    var projection, path;
 
      projection = d3.geo.albersUsa()
        .scale(element.offsetWidth)
        .translate([element.offsetWidth / 2, element.offsetHeight / 2]);
 
    path = d3.geo.path()
      .projection( projection );
 
    return {path: path, projection: projection};
  }
</script>
 
<style>
.datamaps {
  position: relative;
}
</style>
 <script></script>    
  </body>
</html>

var xmess = 0;
var ymess = 10;
var step = 50;

var svg = d3.select("#texta").append("svg")
    .attr("width", 1200)
    .attr("height", 800);

var container_fixed = svg.append("g")
  .attr("width",600)
  .attr("height",200)
  .attr("transform", "translate(0,0)")

var container = svg.append("g")
  .attr("width",600)
  .attr("height",200)
  .attr("transform", "translate("+xmess+","+ymess+")")

var mySquare=container.append("rect")
  .attr("x",5)
  .attr("y",0)
  .attr("rx",30)
  .attr("width",700)
  .attr("height",300)
  .style({'fill':'blue','stroke':'#a0a0a0','stroke-width':5,'fill-opacity':0.1,'stroke-opacity':0.9});


var label = container_fixed.append("foreignObject")
         .attr("x", 850)
         .attr("y", 250)
         .attr("width", 300)
         .attr("height", 300)
         .append("xhtml:body")
         .style({"font-size":"16px","font-family":"Helvetica, Arial, sans-serif", "background-color":"rgba(0, 0, 0, 0)"})
         .style({"color":"rgba(0, 0, 0, 0)", "text-align":"left"})
         .html(" ");

var mymess = container.append("foreignObject")
             .attr("x", 20)
             .attr("y", 10)
             .attr("width", 670)
             .attr("height", 280)
             .append("xhtml:body")
             .style({"font-size":"19px","font-family":"Helvetica, Arial, sans-serif", "background-color":"rgba(0, 0, 0, 0)"})
             .html(" ");

container.style("opacity",0)
var acc = 0,
    delay_var = 1000;

Shiny.addCustomMessageHandler('mess_cb',
  function(data){
    debugger
    mymess.html(data.text)
        
    container.attr("transform", "translate("+xmess+","+ymess+")");
    mySquare.style({'fill':'blue','fill-opacity':0.1});
    
    container.transition()
            .style("opacity",1)
            .each('end', function() { label.html("<table width = 300px class='tg'>\n<col width=150px>\n<col width=150px>\n<tr>\n<th class='tg-ek65'>Customer Name:</th>\n<th class='tg-ek65'> </th>\n</tr>\n<tr>\n<th class='tg-ek65'>Customer Number:</th>\n<th class='tg-ek65'></th>\n</tr>\n<tr>\n<th class='tg-ek65'>Category:</th>\n<th class='tg-ek65'></th>\n</tr>\n<tr>\n<th class='tg-ek65'>Sentiment:</th>\n<th class='tg-ek65'></th>\n</tr>\n<tr>\n<th class='tg-ek65'>Annual Customer Profitability:</th>\n<th class='tg-ek65'></th>\n</tr>\n<tr>\n<th class='tg-ek65'>CLTV:</th>\n<th class='tg-ek65'></th>\n</tr>");
            });
            
    for(i=1;i<6;i++){
      container.transition()
              .delay(delay_var+200*i)
              .duration(50)
              .attr("transform", "translate("+xmess+","+(ymess+step*i)+")");
    }
    container.transition()
            .delay(delay_var+200*(i))
            .each('end', function() {label.html("<table width = 300px class='tg'>\n<col width=150px>\n<col width=150px>\n<tr>\n<th class='tg-ek65'>Customer Name:</th>\n<th class='tg-ek65'> "+data.name+'</th>\n</tr>\n<tr>\n<th class="tg-ek65">Customer Number:</th>\n<th class="tg-ek65"> '+data.cust_number+'</th>\n</tr>\n<tr>\n<th class="tg-ek65">Category:</th>\n<th class="tg-ek65"> '+data.cat+'</th>\n</tr>\n<tr>\n<th class="tg-ek65">Sentiment:</th>\n<th class="tg-ek65"> '+data.sent+"</th>\n</tr>\n<tr>\n<th class='tg-ek65'>Annual Customer Profitability:</th>\n<th class='tg-ek65'> "+data.acp+"</th>\n</tr>\n<tr>\n<th class='tg-ek65'>CLTV:</th>\n<th class='tg-ek65'> "+data.cltv+"</th>\n</tr>");});
    
        
    opacity = '0.3';
    if(data.sent == "Angry"){
      color = 'red';
    }else if(data.sent == "Happy"){
      color = 'green';
    }else if(data.sent == "Very Angry"){
      color = 'red';
      opacity = '0.6';
    }else if(data.sent == "Disappointed"){
      color = 'red';
      opacity = '0.1';
    }else if(data.sent == "Neutral"){
      color = 'gray';
    }
  
    mySquare.transition()
        .duration(100)
        .delay(delay_var+1500)
        .style({'fill':color,'fill-opacity':opacity});
  }
)


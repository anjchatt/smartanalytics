

Shiny.addCustomMessageHandler('HTML_paste',
  function(data){
    d3.select("#html_paste")
      .selectAll('div')
      .remove()
    
    d3.select("#html_paste")
      .append("div")
      .html(data.html);
  })

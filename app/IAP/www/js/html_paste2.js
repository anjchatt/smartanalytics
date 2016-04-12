

Shiny.addCustomMessageHandler('HTML_paste2',
  function(data){
    d3.select("#html_paste2")
      .selectAll('div')
      .remove()
    
    d3.select("#html_paste2")
      .append("div")
      .html(data.html);
  })

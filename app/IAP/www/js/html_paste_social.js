

Shiny.addCustomMessageHandler('HTML_paste_social',
  function(data){
    d3.select("#html_paste_social")
      .selectAll('div')
      .remove()
    
    d3.select("#html_paste_social")
      .append("div")
      .html(data.html);
  })

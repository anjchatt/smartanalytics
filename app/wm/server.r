#library(RPostgreSQL)
library(igraph)
source('ui_func.r')
#source('data_func.r')
#source('data_func2.r')
#source('get_db_con.r')
#source('find_hni.r')

## Get data
# con <- get_db_con()
# hnis_names <- dbGetQuery(con, 'SELECT "Contact.Name" FROM "HighNetWorthInsight.csv"')[,1]

hni_zip_table <- read.csv("data/hni_zip.csv", header=T, as.is=T)
customer_table <- read.csv("data/hni.csv", header=T, as.is=T)
news_table <- read.csv("data/news.csv", header=T, as.is=T)[1:2,]
news_corp_table <- read.csv("data/news_corp.csv", header=T, as.is=T)[1:3,]
events_table <- read.csv("data/events.csv", header=T, as.is=T)
relevant_news_table <- read.csv("data/relevant_news.csv", header=T, as.is=T)
nodes_table <- read.csv("data/deborah-nodes.txt", header=T, as.is=T)
links_table <- read.csv("data/deborah-edges.txt", header=T, as.is=T)
competititor_comp_table <- read.csv("data/compensation.csv", header=T, as.is=T)

## Global variables
time_slot_id <- 0
customer <- list(name="",
                 Email=' ',
                 Adress='',
                 Phone='')

row_names <- c("Investment Assets",
               "Other Assets",
               "Total Assets",
               "Liabilities",
               "Net Worth")

customer.assets_table <- read.csv('data/assets.csv', header=T, sep=',', as.is=T)
names(customer.assets_table) = gsub('[.]',' ',names(customer.assets_table))
customer.assets <- customer.assets_table[1,names(customer.assets_table) != 'timeslot']
customer.assets[,] <- 0
customer.property_table <- read.csv('data/property.csv', header=T, sep=',', as.is=T)
names(customer.property_table) = gsub('[.]',' ',names(customer.property_table))
customer.property <- customer.property_table[1,]
customer.property[,] <- ''
competititor_comp <- competititor_comp_table[1,]
competititor_comp[,] <- ''
#customer.assets <- data.frame(row_names=row_names, values=c(8156870, 2470000, 10626870, -365000, 10261870))

getClientNews <- function(news_table){
  l <- tagList()
  for(i in 1:nrow(news_table)){
    l <- tagList(l,
                 div(style="background-color:#eee; margin-bottom:5px",
                   span(style='color:#888',news_table$date[i]),
                   a(news_table$hni[i],
                     href=paste0('?client=', URLencode(news_table$hni[i]))),
                   br(),
                   strong(news_table$type[i]),
                   br(),
                   span(style='font-size:9pt;', substr(news_table$news[i], 1, 120),
                   '...'))
                 )
  }
  return(l)
}
right.panel.clientNews <- getClientNews(news_table)

getCorpNews <- function(news_corp_table){
  l <- tagList()
  for(i in 1:nrow(news_corp_table)){
    l <- tagList(l,
                 div(style="background-color:#eee; margin-bottom:5px",
                     span(style='color:#888',news_corp_table$date[i]),
                     br(),
                     {
                       if(news_corp_table$type[i]!=""){
                         tagList(strong(news_corp_table$type[i]),br())
                       }
                     },
                     span(style='font-size:9pt;', substr(news_corp_table$news[i], 1, 120)),
                     '...'))
  }
  return(l)
}
right.panel.corpNews <- getCorpNews(news_corp_table)

main.panel.events_header <- c('Event','Date','Source','Category','Sales Insights')
main.panel.events <- data.frame(matrix('', nrow = 1, ncol = 5))
names(main.panel.events) = main.panel.events_header
names(events_table)[1:5] = main.panel.events_header
main.panel.relevant_news_header <- c('Relevant News','Date','Source')
main.panel.relevant_news <- data.frame(matrix('', nrow = 1, ncol = 3))
names(main.panel.relevant_news) = main.panel.relevant_news_header
names(relevant_news_table)[1:3] = main.panel.relevant_news_header

net <- graph.data.frame(links_table, nodes_table, directed=T)
#graph_lyaout<-layout.auto(net)
#write.table(graph_lyaout, 'layout.txt')
graph_lyaout<-as.matrix(read.table('data/layout.txt',header=T))
#parseQueryString(session$clientData$url_search)

shinyServer(function(input, output, session) {
  observe({
    query <<- parseQueryString(session$clientData$url_search)
    if(!('client' %in% names(query))){
      query$client <<- ''
    }
    query$client <<- URLdecode(query$client)
    query$isD <<- query$client=='Deborah Winshel'

    input$updatefltr
    if(isolate(input$client_zip_filter)!=''){
      client_ids <- which(hni_zip_table$ZIP==isolate(input$client_zip_filter))
      hni_zip_table <- hni_zip_table[client_ids,]
    }
    
    if(isolate(input$client_name_filter)!=''){
      name_parts <- strsplit(isolate(input$client_name_filter)[[1]], ' ')[[1]]
      name_parts_det <- grepl(name_parts[1], hni_zip_table$HNI)


      for(ip in 1:length(name_parts)-1){
        name_parts_det <- name_parts_det & grepl(name_parts[ip+1], hni_zip_table$HNI)
      }
      
      hni_zip_table <- hni_zip_table[name_parts_det,]
    }
    
    if((isolate(input$client_zip_filter)!='') || (isolate(input$client_name_filter)!='')){
      end_id <- min(nrow(hni_zip_table), 6)
      if(end_id==0){
        hni_names <- '<span style="color:#F11">No results</span>'
      }else{
        hni_names <- hni_zip_table[1:end_id,'HNI']
        hni_names <- sapply(hni_names, function(x){
          paste0('<a href="?client=',
                 URLencode(x),
                 '">',
                 x,
                 '</a>', collapse='')
        })
        hni_names <- paste0(hni_names,collapse='<br>')
      }
      print(hni_names)
      output$search_results <- renderUI({
        HTML(hni_names)
      })
    }else{
      output$search_results <- renderUI({})
    }
  })
  
  time_slot_id <<- 1
  output$clientNews <- renderUI(right.panel.clientNews)
  output$corpNews <- renderUI(right.panel.corpNews)
  observe({
    input$next_
    if(isolate(query$isD)){
      time_slot_id <<- min(time_slot_id+1, nrow(events_table))
    }else if(input$next_ > 0){
      output$Alerts <- renderUI({
        tagList(div(style='background-color: #FFAC59',
          span(style='color:#555','2015-10-07'),
          a(href=paste0('?client=', URLencode('Deborah Winshel')), 'Deborah Winshel'),
          br(),
          strong('New Appointment'),
#         br(),
#         span(style='font-size:10pt', paste0(substr("BlackRock Appoints Deborah Winshel to Lead Impact Investing Platform BlackRock, Inc. (NYSE:BLK) announces the appointment of Deborah Winshel as a Managing Director and global head of impact investing. In her role, Ms. Winshel will help BlackRock unify its approach to impact investing through the launch of Bl", 1, 140), '...')),
          br(),br())
        )
      })
    }
  })
  observe({
    input$prev_
    if(isolate(query$isD)){
      time_slot_id <<- max(time_slot_id-1, 1)
    }
  })
  output$status <- renderUI({
    input$prev_
    input$next_
    HTML(time_slot_id)})

  observe({
    input$next_
    input$prev_
    if(query$isD){
      customer$name <- customer_table[6,1]
      main.panel.events <- events_table[events_table$TimeSlot<=time_slot_id,]
      main.panel.relevant_news <- relevant_news_table[relevant_news_table$TimeSlot<=time_slot_id,]


      customer.assets <- customer.assets_table
      customer.assets <- customer.assets[customer.assets[,'timeslot']<=time_slot_id,]
      customer.assets <- customer.assets[which.max(customer.assets[,'timeslot']),names(customer.assets)!='timeslot']
      
	    customer.property <- customer.property_table
	    competititor_comp <- competititor_comp_table
      #customer.property <- data.frame(row_names=row_names, values=c(2071709, 0, 2071709, 0, 2071709))
    }
    # General Information
    output$Customer_name <- renderUI(HTML(
      paste0("<h4 style='margin: 0px'>",customer$name,"</h4>")
    ))
    
#     output$contactInfo <- renderUI({
#       table <- paste0('<table width=90% style="font-size: 90%;margin-top:10px;border:0px">',
#                       paste0('<tr><td style="border:0px"><div style="width:60px">',names(customer)[-1],
#                              '</div></td><td style="border:0px">',customer[-1],'</td></tr>',
#                              collapse=''),
#                       "</table>",collapse='')
#       HTML(table)
#     })
    
    
    # events
#     redCol <- sapply(round(events_table$sentiment*255+255),function(v){min(v,255)})
#     yelCol <- sapply(round(-events_table$sentiment*255+255),function(v){min(v,255)})
#    rowstyles <- paste0('style="background-color:rgba(',redCol,',',yelCol,',0,0.5);"')
    
    ##--------------------------------#
    #
    # Events table
    #
    ##--------------------------------#
    
    rowstyles <- paste0('style="background-color:rgba(190,190,256,0.5);"')
    tmp_table <- paste0('<style>.td-events{padding:5px}
                         table,th,td{border: 1px solid white;}</style>',
                           '<table cellpadding="10" style="background-color:#dadafa;margin-top:10px;font-size:100%;width:100%">',
                           '<thead><tr><th class=td-events><div style="width:100px">Event</div>',
                           '</th><th class=td-events>Date',
                           '</th><th class=td-events>Source',
                           '</th><th class=td-events>Category',
                           '</th><th class=td-events>Sales Insights',
                           '</th></tr></thead>',
                           paste0('<tr ',rowstyles,'><td class=td-events>',main.panel.events[,'Event'],
                                  '</td><td class=td-events>',main.panel.events[,'Date'],
                                  '</td><td class=td-events>',main.panel.events[,'Source'],
                                  '</td><td class=td-events>',main.panel.events[,'Category'],
                                  '</td><td class=td-events>',main.panel.events[,'Sales Insights'],'</td></tr>',
                                  collapse=''),
                           "</table>",collapse='')
    output$events <- renderUI(HTML(tmp_table))

    ##--------------------------------#
    #
    # Alerts
    #
    ##--------------------------------#
    
    if(query$isD){
      output$Alerts <- renderUI({
        tagList(div(style='background-color: #FFAC59',
                    span(style='color:#555',main.panel.events[1,'Date']),
                    a(href=paste0('?client=', URLencode('Deborah Winshel')), 'Deborah Winshel'),
                    br(),
                    strong(main.panel.events[1,'Event']),
                    br(),br())
        )
      })
    }

    ##--------------------------------#
    #
    # Relevant news table
    #
    ##--------------------------------#

    output$relevant_news <- renderUI(HTML(
      paste0('<style>.td-events{padding:5px}
                        table,th,td{border: 1px solid white;}</style>',
                        '<table cellpadding="10" style="background-color:#dadafa;margin-top:10px;font-size:100%;width:100%">',
                        '<thead><tr><th class=td-events><div style="width:100px">Relevant News</div>',
                        '</th><th class=td-events>Date',
                        '</th><th class=td-events>Source',
                        '</th></tr></thead>',
                        paste0('<tr ',rowstyles,'><td class=td-events>',main.panel.relevant_news[,'Relevant News'],
                               '</td><td class=td-events>',main.panel.relevant_news[,'Date'],
                               '</td><td class=td-events>',main.panel.relevant_news[,'Source'],'</td></tr>',
                               collapse=''),
                        "</table>",collapse='')
    ))

    ##--------------------------------#
    #
    # Netowork plot
    #
    ##--------------------------------#
    
    if(isolate(query$isD)){
      # data
      nodes_table_ids <- nodes_table$timeslot <= time_slot_id
      nodes_table2 <- nodes_table[nodes_table_ids,]
      graph_lyaout <- graph_lyaout[nodes_table_ids,]
      links_table_ids <- links_table$from %in% nodes_table2$id
      links_table_ids <- links_table_ids & (links_table$to %in% nodes_table2$id)
      links_table2 <- links_table[links_table_ids,]
      
      net <- graph.data.frame(links_table2, nodes_table2, directed=T)
      
      # params
      colrs <- c("#B8E721", "#158D92", "#F28222", "#B0198F")
      V(net)$color <- colrs[V(net)$type]
      V(net)$frame.color <- NA
      V(net)$label.color <- "black"
      V(net)$label.cex <- 0.8
      E(net)$label.cex <- 0.6
      V(net)$size <- 7
      E(net)$arrow.mode <- 0
      
      nodes_table2$group[is.na(nodes_table2$group)] <- 0
      ngr <- max(nodes_table2$group)
      groups <- c()
      for(i in 1:ngr){
        groups <- c(groups, list(which(nodes_table2$group==i)))
      }
      
      output$connPlot <- renderPlot({
#      colrs <- c("#B8E721", "#158D92", "#F28222", "#B0198F")
        p<-plot(net,
                edge.label=E(net)$type,
                vertex.label=V(net)$name,
                mark.groups=groups,
                layout=graph_lyaout)
        
        legend(x=-1, y=-1, c("Person", "Company", "School", "Conference"), pch=21,
               col="#777777", pt.bg=colrs, pt.cex=2, cex=.8, bty="n", ncol=1)
        return(p)
      },height = 800, res = 110)
      
      output$mini_network <- renderPlot({
        plot(net)
        plot(net,
             vertex.label='',
             vertex.size = 20,
             mark.groups=groups,
             layout=graph_lyaout,
             margin = -0.7)
      },height = 190)
      
    }
    
    ##--------------------------------#
    #
    # Assets plot
    #
    ##--------------------------------#
    
    output$assetPlot <- renderPlot({
      p<-qplot(x=names(customer.assets)[c(1,4,2)],

                                             y=as.numeric(customer.assets[,c(1,4,2)]),
                                             geom='bar',
                                             stat='identity',
                                             ylab=c(),xlab=c(),
                                             fill=c('2','1','3'))
      p+theme(legend.position="none")},
    height = 170)
    
    ##--------------------------------#
    #
    # Assets table
    #
    ##--------------------------------#
    
    output$asset_table <- renderUI({
      rowstyles <- c('','','',' style="border-bottom:solid"','')
      HTML(paste0('<table width=100% style="background-color:#dadafa;margin-top:10px;font-size:80%">',
                  paste0('<tr ',rowstyles,'><td>',names(customer.assets),
                         '</td><td> $ ',prettyNum(customer.assets[1,],big.mark=",",scientific=FALSE),'</td></tr>',
                         collapse=''),
                  "</table>",collapse=''))
    })
    output$property_table <- renderUI({
      tmp_tabe2 <- '<div style="height:100px;border:1px solid #ccc;overflow:auto;"><table width=100% style="background-color:#dadafa;margin-top:10px;font-size:80%">'
      for(i in 1:nrow(customer.property)){
        tmp_tabe2 <- paste0(tmp_tabe2,
                            '<tr><td colspan="2" style="background-color:#aaaafa;">Property #',i,'</td></tr>',
                            paste0('<tr><td width=60%>',names(customer.property),
                                   '</td><td>',customer.property[i,],'</td></tr>',
                                   collapse=''), collapse='')
      }
      tmp_tabe2 <- paste0(tmp_tabe2,"</table></div>",collapse='')
      HTML(tmp_tabe2)
    })
    
    # Competitor sallaries
    table_comp_salary <- paste0('<table width="100%" style="background-color:#dadafa;margin-top:10px;font-size:100%">',
                                '<thead><tr><th class=td-events>Name',
                                '</th><th class=td-events><div style="width:100px">Position</div>',
                                '</th><th class=td-events>Compensation',
                                '</th></tr></thead>',
                                paste0('<tr><td>',competititor_comp$Name,
                                       '</td><td class=td-events>',competititor_comp$Position,
                                       '</td><td class=td-events>',competititor_comp$Compensation,'</td></tr>',
                                       collapse=''),
                                "</table>",collapse='')
    output$comp_salary <- renderUI(HTML(table_comp_salary))
    
  })
  
  #  wmfbdata <- get_wm_fb_feeds()
  #  events <- rbind(wmdata$events, wmfbdata$events)
  
  

  #rnews <- rbind(wmdata$rnews, wmfbdata$rnews)
  
#   events <- data.frame(category=c("cat1events", "cat2", "cat3"),
#                        keywords=c("kw1, kw2, kw3", "c2kw1, c2kw2, c2kw3", "c3kw1, c3kw2, c3kw3"),
#                        sources=c('http://src1','http://src2','http://src3'),
#                        sentiment=c(-0.99,0,0.99),
#                        proposed_action=c('act1', 'act2', 'act3'))
#   
#   rnews <- data.frame(category=c("cat1news", "cat2", "cat3"),
#                       keywords=c("kw1, kw2, kw3", "c2kw1, c2kw2, c2kw3", "c3kw1, c3kw2, c3kw3"),
#                       sources=c('http://src1','http://src2','http://src3'),
#                       sentiment=c(-0.99,0,0.99))

  # customer name
#   renderCustomHTML(id="Customer_name",
#                    html=paste0("<h3 style='margin: 10px'>",customer$name,"</h3>"),
#                    session=session)

  
  # customer contact information
#   output$contactInfo <- renderUI({
#     table <- paste0('<table width=90% style="font-size: 90%;margin-top:10px;border:0px">',
#                     paste0('<tr><td style="border:0px"><div style="width:60px">',names(customer)[-1],
#                            '</div></td><td style="border:0px">',customer[-1],'</td></tr>',
#                            collapse=''),
#                     "</table>",collapse='')
#     HTML(table)
#   })
  
  

  # rnews
#  redCol <- sapply(round(rnews$sentiment*255+255),function(v){min(v,255)})
#  yelCol <- sapply(round(-rnews$sentiment*255+255),function(v){min(v,255)})
  
#   rowstyles <- paste0('style="background-color:rgba(',redCol,',',yelCol,',0,0.5);"')
#   table_rnews <- paste0('<table width=100% style="background-color:#dadafa;margin-top:10px;font-size:100%">',
#                         '<thead><tr><th class=td-events><div style="width:100px">Category</div>',
#                         '</th><th class=td-events>Key entities',
#                         '</th><th class=td-events>Source',
#                         '</th></tr></thead>',
#                         paste0('<tr ',rowstyles,'><td  class=td-events>',rnews$category,
#                                '</td><td  class=td-events>',rnews$keywords,
#                                '</td><td  class=td-events><a href="',rnews$sources,'">',substring(rnews$sources,1,30),'...</a>',
#                                collapse=''),
#                         "</table>",collapse='')
  
  
  # lnews
#  redCol <- sapply(round(lnews$sentiment*255+255),function(v){min(v,255)})
#  yelCol <- sapply(round(-lnews$sentiment*255+255),function(v){min(v,255)})
#  rowstyles <- paste0('style="background-color:rgba(',redCol,',',yelCol,',0,0.5);"')
#   rowstyles <- paste0('style="background-color:rgba(128,128,128,0.5);"')
#   
#   table_lnews <- paste0('<table width="100%" style="background-color:#dadafa;margin-top:10px;font-size:100%">',
#                         '<thead><tr><th class=td-events>Category',
#                         '</th><th class=td-events><div style="width:100px">Key words</div>',
#                         '</th><th class=td-events>Source',
#                         '</th></tr></thead>',
#                         paste0('<tr ',rowstyles,'><td>',lnews$category,
#                                '</td><td class=td-events>',lnews$keywords,
#                                '</td><td class=td-events>',lnews$sources,'</td></tr>',
#                                collapse=''),
#                         "</table>",collapse='')
#   output$lnews <- renderUI(HTML(table_lnews))
})

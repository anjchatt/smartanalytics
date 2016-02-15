# install.packages("leaflet")
# install.packages("geosphere")
library(leaflet)

load("LM_clusters.bin")

col.names.tr <- list("Geo: US","Geo: EU","Geo: Asia","Geo: Africa",
                     "Currency: USD","Currency: EU","Currency: Other",
                     "Type: Exchange","Type: Transfer","Type: Purchase","Type: Other",
                     "Method: ATM","Method: Card","Method: ecommerce","Method: Webbank","Method: Mobile",
                     "Receiver: Mixed","Receiver: Technology","Receiver: Restaurants",
                     "Receiver: Grocery","Receiver: Service","Receiver: Travel related","Receiver: Other")
names(col.names.tr) = names(data$df)[1:23]
col.names.bh <- list("Communication: MobileApp","Communication: Web","Communication: email",
                     "Communication: Phone","Duration: Less than 1 min","Duration: Less than 5 min",
                     "Duration: Longer than 5 min","Topic: Cards","Topic: Account information",
                     "Topic: Loan products","Topic: Offers","Finish with an action","Response to ads: Travel",
                     "Response to ads: Clothes","Response to ads: Restaurant","Response to ads: Car")
names(col.names.bh) = names(data$df)[24:(24+15)]
col.names.pers <- list("category", "Age","Is male","Home State")
names(col.names.pers) = names(data$df)[40:43]
names(data$df) = c(col.names.tr,col.names.bh,col.names.pers,'tr','bh')
nr <- nrow(data$df)
probs <- c(0.75,0.21,0.16,0.28)

response <- runif(nr)<probs[data$df$tr]
data$df <- cbind(data$df,
                 list(
                   dnc=runif(nr)>0.95,
                   response=response))

map_maprkers <- read.csv('map_maprkers.csv',sep=";",stringsAsFactors=F)
dt <- read.csv('parameters.csv',sep=";",stringsAsFactors=F)
dt$Event.Distance <- apply(dt, 1, function(x){
  dist <- geosphere::distGeo(
    c(as.numeric(x['Current.Location.lat']),
      as.numeric(x['Current.Location.lng'])),
    c(as.numeric(x['Event.Location.lat']),
      as.numeric(x['Event.Location.lng'])))
  if(nchar(x['Upcomming.event'])<5){
    dist <- ' - '
  } else{
    dist <- paste0(round(dist/100)/10, ' km')
  }
})
dt$Home.Distance <- apply(dt, 1, function(x){
  dist <- geosphere::distGeo(
    c(as.numeric(x['Current.Location.lat']),
      as.numeric(x['Current.Location.lng'])),
    c(as.numeric(x['Home.Location.lat']),
      as.numeric(x['Home.Location.lng'])))
  dist <- paste0(round(dist/100)/10, ' km')
})


names(dt) <- gsub("[.]", ' ', names(dt))
# 'Evening bar meeting with friends'

time_slot <- 0
data_df_s <- c()
xy_store <- matrix(rep(0,9),3,3)

shinyServer(function(input, output, session) {
  ## init data
  ids <- sample(nrow(data$df),500)
  data_df_s <<- data$df[ids,]
  xy_store <<- matrix(rep(0,9),3,3)
  
  
  ## ## ## ## ## ## ## ##
  ## Scenario
  ## ## ## ## ## ## ## ##
  time_slot <<- 1
  observe({
    input$prev_
    time_slot <<- max(time_slot-(input$prev_>0),1)
  })
  observe({
    input$next_
    time_slot <<- min(time_slot+(input$next_>0),nrow(dt))
  })
  
  observe({
    input$next_
    input$prev_
    ## Map
    output$prediction_map <- renderLeaflet({
      m <- leaflet()
      m <- addTiles(m)
      m <- addMarkers(m,
                      lng=dt$'Current Location lng'[time_slot], 
                      lat=dt$'Current Location lat'[time_slot], 
                      popup="Customer location")
      m <- setView(m, 
                   zoom = 14,#dt$'Map Zoom'[time_slot], 
                   lng=dt$'Current Location lng'[time_slot], 
                   lat=dt$'Current Location lat'[time_slot])
      
      map_maprkers2 <- map_maprkers[map_maprkers$time_slot == time_slot,]
      if(nrow(map_maprkers2) > 0){
        m <- addCircleMarkers(
          m,
          lng = map_maprkers2$lng,
          lat = map_maprkers2$lat,
          radius = map_maprkers2$size,
          popup = map_maprkers2$popup,
          stroke = FALSE, fillOpacity = 0.5
        )
      }
      m
    })
    
    output$oppinfo <- renderUI(HTML(paste0(
      dt$'Opportunity Message'[time_slot],
      collapse="")))

    output$smsinfo <- renderUI(HTML(paste0(
      '<div style="background:#fdd">',
        dt$'Latest SMS'[time_slot],
      '</div>',
      collapse="")))
    
    output$locinfo <- renderUI(HTML(paste0(
      '<style> td.pad5 { padding: 5px 0px 5px 0px;}',
              'td.bord {border-bottom: 1px solid black}',
              'hl {background-color: #f99}</style>',
       '<table width = "100%" cellspacing="10" cellpadding="10">',
        '<tr>',
          '<td class="pad5 bord">Current Date</td>',
          '<td class="pad5 bord">',dt$'Current Date'[time_slot],'</td>',
        '</tr>',
        '<tr>',
          '<td class="pad5 bord">Current Time</td>',
          '<td class="pad5 bord">',dt$'Current Time'[time_slot],'</td>',
        '</tr>',
        '<tr>',
          '<td class="pad5 bord">Last Activity</td>',
          '<td class="pad5 bord">',dt$'Last Action'[time_slot],'</td>',
        '</tr>',
        '<tr>',
          '<td class="pad5 bord">Distance to home</td>',
          '<td class="pad5 bord">',dt$'Home Distance'[time_slot],'</td>',
        '</tr>',
        '<tr>',
          '<td class="pad5">Weather</td>',
          '<td class="pad5">',dt$'Weather'[time_slot],'</td>',
        '</tr>',
      '</table>',
      collapse="")))
    
    output$transinfo <- renderUI(HTML(paste0(
      '<table width = "100%" cellspacing="10" cellpadding="10">',
        '<tr>',
          '<td class="pad5 bord">Last transaction date</td>',
          '<td class="pad5 bord">',dt$'Current Date'[time_slot],'</td>',
        '</tr>',
        '<tr>',
          '<td class="pad5 bord">Transaction Amount</td>',
          '<td class="pad5 bord">',dt$'Transaction Amount'[time_slot],'</td>',
        '</tr>',
        '<tr>',
          '<td class="pad5">Merchant Type</td>',
          '<td class="pad5">',dt$'Merchant Type'[time_slot],'</td>',
        '</tr>',
      '</table>',
      collapse="")))
    
    
    output$sninfo <- renderUI(HTML(paste0(
      '<strong>Last message</strong><br>',
      '<span style="color:#777">',dt$'Last SN message time'[time_slot],'</span>',
      '<br>',
      '<div style="background-color:#ddd">',
      '<i>',dt$'Last SN message'[time_slot],'</i>',
      '</div>',
      '<br>',
      
      '<strong>Upcomming Event</strong><br>',
      '<span style="color:#777">',dt$'Event time'[time_slot],'</span>',
      '<br>',
      '<div style="background-color:#ddd">',
      '<i>',dt$'Upcomming event'[time_slot],'</i>',
      '</div>',
      'Distance to event: ',
      dt$'Event Distance'[time_slot],
      collapse="")))
      
  })

  ## Photo
  output$customer_photo <- renderUI({
    tagList(
      img(src='./001/photo2.jpg', width="100%"),
      HTML('<table width="100%" style="margin-top: 10px"><tr><td>Customer Name</td><td><strong>John Smith</strong></td></tr><tr><td>Customer Age</td><td><strong>32</strong></td></tr></table>')
    )
  })
  
  
  source('server_pages/loyalty_sent.r', local=TRUE)
  
  ## ## ## ## ## ## ## ##
  ## Filters
  ## ## ## ## ## ## ## ##
  data_df <- reactive({
    input$updatefltr
    data_df <- data$df
    data_df <- data_df[data_df$Age>=isolate(input$sel_age[1]),]
    data_df <- data_df[data_df$Age<=isolate(input$sel_age[2]),]
    if(isolate(input$sel_sex) == 'Male'){
      data_df <- data_df[data_df[,'Is male'],]
    }else if(isolate(input$sel_sex) == 'Female'){
      data_df <- data_df[!data_df[,'Is male'],]
    }
    if(length(isolate(input$sel_state))>0){
      data_df <- data_df[data_df[,'Home State'] %in% isolate(input$sel_state),]
    }
    if(isolate(input$sel_dnc)=='Yes'){
      data_df <- data_df[data_df[,'dnc'],]
    }else if(isolate(input$sel_dnc)=='No'){
      data_df <- data_df[!data_df[,'dnc'],]
    }
    nr <- nrow(data_df)
    nr2 <- min(nr, 500)
    ids <- sample(nr,nr2)
    data_df_s <<- data_df[ids,]
    return(data_df)
  })

  ## ## ## ## ## ## ## ##
  ## Results
  ## ## ## ## ## ## ## ##
  output$parameters <- renderUI({
    data_df <- data_df()
    nr<- nrow(data_df)
    
    ## Update info by click
    a1 <- c(14, 8, 15)
    a2 <- c(5, 22, 24)
    selected_c <- ''
    
    for (yi in 1:3){
      for (xi in 1:3){
        name_plot <- paste0('plot',xi,yi,'_click')
        if (!is.null(input[[name_plot]]$x)){
          x_ <- input[[name_plot]]$x
          y_ <- input[[name_plot]]$y
          
          if(xy_store[yi,xi] != y_*3+x_){
            xy_store[yi,xi] <<- y_*3+x_
            
            dx <- x_-data_df_s[,a1[xi]]
            dy <- y_-data_df_s[,a2[yi]]
            di <- which.min(dx^2+dy^2)
            
            selected_c <- paste0(
              '<table>',
              '<tr><td>','USD currency:</td><td>',round(data_df_s[di,a1[1]]*10)/10,'</td>',
              '<tr><td>','Currency exchange:</td><td>', round(data_df_s[di,a1[2]]*10)/10,'</td>',
              '<tr><td>','Transfers:</td><td>', round(data_df_s[di,a1[3]]*10)/10,'</td>',
              '<tr><td>','Internet shopping:</td><td>', round(data_df_s[di,a2[1]]*10)/10,'</td>',
              '<tr><td>','Travelling freq:</td><td>', round(data_df_s[di,a2[2]]*10)/10,'</td>',
              '<tr><td>','Mobile app usage:</td><td>', round(data_df_s[di,a2[3]]*10)/10,'</td>',
              '</table>'
            )
          }
        } 
      }
    }
    
    t<-paste0('Number of customers:<br>',nr,'<br><br>',
              'Number of responded customers:<br>',sum(data_df$response),'<br><br>',
              'Response rate:<br>',round(sum(data_df$response)/nr*100),'%<br><br>',
              '<hr><div style="background-color: #ddd">Selected Customer</div><br>',
              selected_c,
              collapse='')
    return(HTML(t))
  })

  ## ## ## ## ## ## ## ##
  ## PLOTS
  ## ## ## ## ## ## ## ##
  observe({
    input$updatefltr
    output$scatterplot11 <- renderPlot({
      palette(c('#ED6406', '#D6E906', '#7C099D', '#04967E'))
      par(mar=c(0,0,0,0), bty = 'n', xaxt='n', yaxt='n', pch=20)
      plot(data_df_s[,c(14,5)],
           col=data_df_s$tr)
    }, height=200)
    output$scatterplot21 <- renderPlot({
      par(mar=c(0,0,0,0), bty = 'n', xaxt='n', yaxt='n', pch=20)
      plot(data_df_s[,c(8,5)],
           col=data_df_s$tr)
    }, height=200)
    output$scatterplot31 <- renderPlot({
      par(mar=c(0,0,0,0), bty = 'n', xaxt='n', yaxt='n', pch=20)
      plot(data_df_s[,c(15,5)],
           col=data_df_s$tr)
    }, height=200)
    output$scatterplot12 <- renderPlot({
      par(mar=c(0,0,0,0), bty = 'n', xaxt='n', yaxt='n', pch=20)
      plot(data_df_s[,c(14,22)],
           col=data_df_s$tr)
    }, height=200)
    output$scatterplot22 <- renderPlot({
      par(mar=c(0,0,0,0), bty = 'n', xaxt='n', yaxt='n', pch=20)
      plot(data_df_s[,c(8,22)],
           col=data_df_s$tr)
    }, height=200)
    output$scatterplot32 <- renderPlot({
      par(mar=c(0,0,0,0), bty = 'n', xaxt='n', yaxt='n', pch=20)
      plot(data_df_s[,c(15,22)],
           col=data_df_s$tr)
    }, height=200)
    output$scatterplot13 <- renderPlot({
      par(mar=c(0,0,0,0), bty = 'n', xaxt='n', yaxt='n', pch=20)
      plot(data_df_s[,c(14,24)],
           col=data_df_s$tr)
    }, height=200)
    output$scatterplot23 <- renderPlot({
      par(mar=c(0,0,0,0), bty = 'n', xaxt='n', yaxt='n', pch=20)
      plot(data_df_s[,c(8,24)],
           col=data_df_s$tr)
    }, height=200)
    output$scatterplot33 <- renderPlot({
      par(mar=c(0,0,0,0), bty = 'n', xaxt='n', yaxt='n', pch=20)
      plot(data_df_s[,c(15,24)],
           col=data_df_s$tr)
    }, height=200)
  })
#   output$scatterplot_tr <- renderPlot({
#     nr <- nrow(data_df())
#     nr2 <- min(nrow(data_df()), 1000)
#     ids <- sample(nr,nr2)
#     plot(data_df()[ids,c(1,5,13)],
#          col=data_df()$tr[ids])
#   })
#   output$scatterplot_bh <- renderPlot({
#     nr <- nrow(data_df())
#     nr2 <- min(nrow(data_df()), 1000)
#     ids <- sample(nr,nr2)
#     plot(data_df()[ids,c(24,29,37)],
#          col=data_df()$bh[ids])
#   })
  
  output$barplot_tr <- renderPlot({
    tmp_counts <- as.data.frame(table(data_df()$tr))
    precounts <- tmp_counts$Freq
    prenames <- tmp_counts[[1]]
    snames <- 1:4
    counts <- rep(0,length(snames))
    counts[snames %in% prenames] <- precounts
    snames_t <- paste0('Segment #',snames)
    
    barplot(counts,
            main = "Segments",
            names.arg = snames_t,
            col = snames)
  })
  
  output$barplot_bh <- renderPlot({
    tmp_counts <- as.data.frame(table(data_df()$bh))
    precounts <- tmp_counts$Freq
    prenames <- tmp_counts[[1]]
    snames <- 1:4
    counts <- rep(0,length(snames))
    counts[snames %in% prenames] <- precounts
    snames_t <- paste0('Segment #',snames)
    barplot(counts,
            main = "Segments",
            names.arg = snames_t,
            col = snames)
  })
})

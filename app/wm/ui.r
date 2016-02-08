source('ui_func.r')
library(ggplot2)
cat_names <- list('Retirement Plan','Investment Management',
                  'Estate Planning','Financial Planning',
                  'Tax Planning','Insurance',
                  'Asset Protection','Banking',
                  'Education Planning','Mortgage',
                  'Real Estate')


shinyUI(fluidPage(
  tags$script(src='/d3.min.js'),
  tags$style("body{background: #f0fff0;min-width: 1000px;}"),
  fluidRow(
    column(9,
      
      # Name
      column(4,
        box(tagList(
          tags$span(style='text-align:center;',
            htmlOutput("Customer_name")),
          htmlOutput('contactInfo')),
          'height:50px;border-color:#44f;background-color:rgba(0,0,255,0.2)'),
       box(tagList(
         plotOutput('mini_network', height=190)
       ))
      ),
      
      # Assets
      column(8,box(tagList(
        fluidRow(
          column(7,
            plotOutput("assetPlot", height=170)),
          column(5,
            htmlOutput("asset_table")),
          column(7,
            htmlOutput("property_table")),
          column(5,
            htmlOutput("contact_table"))
        )),
          "height:280px;
          padding-top:0")
      ),
      # Events
      column(12,
        box(tagList(
          tabsetPanel(
            tabPanel("Events",
              htmlOutput('events')),
            tabPanel("Connections Network",
              plotOutput("connPlot", height=800)),
            
            tabPanel("Compensation",
              htmlOutput('comp_salary')
            )
          ),
          br(),
          br(),
          # Local News
          tagList(
            htmlOutput('relevant_news'))
        ))
      )
    ),
    # Right Panel
    column(3,
      box(tagList(
        h3(style='margin: 10px;text-align:center;',"Fast filters"),
        textInput("client_name_filter", "Name:"),
        textInput("client_zip_filter", "Zip:"),
        actionButton('updatefltr', 'Find', style='background-color:#428bca; color:#fff'),
        br(),
        htmlOutput('search_results'),
        br(),
        h4('Smart Analytics Alerts'),
        htmlOutput('Alerts'),
        
        hr(style='margin:0px'),
        h4('Client News'),
        htmlOutput('clientNews'),
        
        hr(style='margin:0px'),
        h4('Client Company M&A News'),
        htmlOutput('corpNews'),
        
        h4('SocialNews','Social Media Insights'),
        hr(style='margin:0px')
      ))
    )
  ),
  div(style='position: fixed;
      right: 0;
      top: 0;', actionLink('prev_','prev'), actionLink('next_','next')
  ),
  div(style='position: fixed;
        left: 20px;
        bottom: 20px;
        width: 300px;
        border: 3px solid #8AC007', htmlOutput('status')
  )
))
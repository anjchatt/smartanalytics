library(leaflet)
source('ui_pages/ui_func.r')

shinyUI(navbarPage("Smart Analytics", theme = 'bootstrap.css',

  ##
#  {source('ui_pages/segmentation.r', local=TRUE),
  tabPanel('Segmentation',
  fluidRow(
    column(3,
           box(tagList(
             h3("Parameters"),
             htmlOutput('parameters')
           )),
           HTML(
             '<div class="panel panel-default">
             <div class="panel-heading" style="background-color: rgba(237, 100, 6, 0.7)">
             <h3 class="panel-title">International traveller</h3>
             </div>
             </div>
             <div class="panel panel-default">
             <div class="panel-heading" style="background-color:rgba(214, 233, 6, 0.7)">
             <h3 class="panel-title">Premium shopper</h3>
             </div>
             </div>
             <div class="panel panel-default">
             <div class="panel-heading" style="background-color: rgba(124, 9, 157, 0.7)">
             <h3 class="panel-title">Active internet users</h3>
             </div>
             </div>
             <div class="panel panel-default">
             <div class="panel-heading" style="background-color: rgba(4, 150, 126, 0.8)">
             <h3 class="panel-title">Cashback only users</h3>
             </div>
             </div>'
           )
    ),
    column(6,
           box(tagList(
             h3("Plot"),
             tags$style('tr.bord_sc_btm {border-bottom: 1px solid #888}
                        td.bord_sc_rt {border-right: 1px solid #888}'),
             tags$style(paste0(
               '.outer {position: relative;display: inline-block;}',
               '.inner_rot {position: absolute;top: 50%;left: 50%;',
               'white-space:nowrap;',
               '-moz-transform: translateX(-50%) translateY(-50%) rotate(-90deg);',
               '-webkit-transform: translateX(-50%) translateY(-50%) rotate(-90deg);',
               'transform:  translateX(-50%) translateY(-50%) rotate(-90deg);}')),
             tags$table(style="width:100%;",
               tags$tr(
                 tags$td(style='vertical-align: bottom',
                   width = '20',
                   div(class='outer', style="height:600px",div(class='inner_rot',tags$b("Behavior")))
                 ),
                 tags$td(
                   div(style='font-size: 120%;text-align: center;margin = 0px 0px 0px 0px;',tags$b("Transactions")),
                   tags$table(style="width:100%;",width="100%",
                     tags$tr(style="text-align:center",
                       tags$td(),
                       tags$td(tags$i('USD currency')),
                       tags$td(tags$i('Currency exchange')),
                       tags$td(tags$i('Transfers'))
                     ),
                     tags$tr(
                       class='bord_sc_btm',
                       tags$td(width="10",div(class='outer',div(class='inner_rot',tags$i("Internet shopping")))),
                       tags$td(class='bord_sc_rt',width = '33%',plotOutput("scatterplot11", height=200, click = "plot11_click")),
                       tags$td(class='bord_sc_rt',width = '33%',plotOutput("scatterplot21", height=200, click = "plot21_click")),
                       tags$td(plotOutput("scatterplot31", height=200, click = "plot31_click"))),
                     tags$tr(
                       class='bord_sc_btm',
                       tags$td(width="10",div(class='outer',div(class='inner_rot',tags$i("Travelling freq")))),
                       tags$td(class='bord_sc_rt',width = '33%',plotOutput("scatterplot12", height=200, click = "plot12_click")),
                       tags$td(class='bord_sc_rt',width = '33%',plotOutput("scatterplot22", height=200, click = "plot22_click")),
                       tags$td(plotOutput("scatterplot32", height=200, click = "plot32_click"))),
                     tags$tr(
                       tags$td(width="10",div(class='outer',div(class='inner_rot',tags$i("Mobile app usage")))),
                       tags$td(class='bord_sc_rt',width = '33%',plotOutput("scatterplot13", height=200, click = "plot13_click")),
                       tags$td(class='bord_sc_rt',width = '33%',plotOutput("scatterplot23", height=200, click = "plot23_click")),
                       tags$td(plotOutput("scatterplot33", height=200, click = "plot33_click"))
                     )
                   )
                 )
               )
             )
            ))
#              tabsetPanel( 
#                tabPanel("Transaction",
#                         plotOutput("scatterplot_tr"),
#                         plotOutput("barplot_tr")),
#                tabPanel("Behavior",
#                         plotOutput("scatterplot_bh"),
#                         plotOutput("barplot_bh"))
#              )
#           ))
    ),
    column(3,
           box(tagList(
             h3("Filters"),
             sliderInput("sel_age", label = "Age", min = 20, max = 60, value = c(10, 90)),
             selectInput('sel_state', 'State', state.name, multiple=TRUE, selectize=TRUE),
             selectInput('sel_sex', 'Sex', c('Any', 'Male', 'Female'), multiple=FALSE, selectize=TRUE),
             selectInput('sel_dnc', 'Do Not Contact List', c('Any', 'Yes', 'No'), multiple=FALSE, selectize=TRUE),
             actionButton('updatefltr', 'Apply filters', style='background-color:#428bca; color:#fff')
           #),"position: fixed; width:24%; height:85%;right: 0px;background-color:#cceeff") 
           ),"background-color:#cceeff"
         )
       )
      ),
    br(),
    br(),
    fluidRow(
      {t <- readLines('ui_pages/loyalty_mess.html')
      HTML(paste0(t,collapse='\n'))}
    )
  ),
#    a01_segmentation}, 
# {source('ui_pages/loyalty_mess.r', local=TRUE)
#     a02_loyalty_mess},

  
  tabPanel('Predictive Insights',
    tags$style(type="text/css",
      "body {
        padding-top: 70px;
        background: #f0fff0;
      }"),
#      .navbar-default {background-color:rgb(80, 39, 76);}"),
           
    column(3,
      box(tagList(
        htmlOutput('customer_photo'))),
      box(tagList(
        span(style="font-size: 150%",strong("Social networks")),
        hr(style="margin:5px"),
        htmlOutput('sninfo')))),
    column(3,
      box(tagList(
        span(style="font-size: 150%",strong("Current status")),
        htmlOutput('locinfo'))),
      box(tagList(
        span(style="font-size: 150%",strong("Last transaction")),
        htmlOutput('transinfo')))),
    column(6,
      box(tagList(
        leafletOutput('prediction_map',height=350))),
      box(tagList(
        tags$table(width="100%",
          tags$tr(
            tags$td(width="50%",
              span(style="font-size: 100%",strong("Loyalty Improvement Opportunity")),
              hr(style="margin:5px")),
            tags$td(width="50%",
              span(style="font-size: 100%",strong("Latest offer")),
              hr(style="margin:5px"))
          ),
          tags$tr(
            tags$td(
              htmlOutput('oppinfo')),
            tags$td(
              htmlOutput('smsinfo'))
          )
        )
      ))
    ),
    htmlOutput('prediction_page'),
    div(style='position: fixed;
      right: 10px;
      top: 55px;', actionLink('prev_','prev'), actionLink('next_','next')
  )),

#  {source('ui_pages/prediction.r', local=TRUE)
#    a03_prediction},
  {source('ui_pages/loyalty_sent.r', local=TRUE)
    a04_loyalty_sent},
  


  position = 'fixed-top',
  inverse=T
))
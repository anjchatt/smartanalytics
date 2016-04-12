library(shinydashboard)


## INCLUDES

reactiveMap <- function (outputId) 
{
  HTML(paste("<div id=\"", outputId, "\" class=\"draw-map\"><svg /></div>", sep=""))
}

reactiveCLTVBar <- function ()
{
  HTML('<div id=barplot></div>
    <script src="/js/barplot.js"></script>')
}

reactiveCLTVChart <- function ()
{
  HTML('<div id=cltvplot></div>
    <script src="/js/cltvplot.js"></script>')
}

reactiveTexta <- function ()
{
  HTML(paste('
        <div id=texta></div>
        <script src="/js/texta.js"></script>'))
}

reactiveLinks <- function ()
{
  HTML(paste('
        <div id=set_links></div>
        <script src="/js/links.js"></script>'))
}

reactiveHTML <- function ()
{
  HTML(paste('
        <br>
        <div id=html_paste></div>
        <script src="/js/html_paste.js"></script>'))
}

reactiveHTML2 <- function ()
{
  HTML(paste('
        <br>
        <div id=html_paste2></div>
        <script src="/js/html_paste2.js"></script>'))
}

reactiveHTML_social <- function ()
{
  HTML(paste('
        <br>
        <div id=html_paste_social></div>
        <script src="/js/html_paste_social.js"></script>'))
}

## GLOBAL



## UI

shinyUI(
  navbarPage(
    title="",
    position="static-top",
#    position="fixed-top",
    collapsible=F,
    
    
###### HOME TAB
      
      
      
    tabPanel("Home",
	tags$script(src = "raw/descriptions.js"),
#      column(12, offset=0,
#		column(2, offset=0,
#			h1(class="taboffset", "Smart Analytics Platform")),
#        column(2, offset=0,
#			h1(class="taboffset", "Smart Analytics Platform")),
#	  ),
      column(12, offset=0,
		column(4, offset=0,
			tags$img(style='margin-top: 50px;', src = "raw/cglogo.png")),
		column(4, offset=0,
			h1(style='margin-top: 50px; margin-bottom: 50px; text-align:center;', "Smart Analytics Platform")),
		column(3, offset=1,
			h4(style='margin-top: 60px; text-align:center;', "Powered by IBM Bluemix"))
	  ),
      column(10, offset=1,
        reactiveLinks()
      )

    ),
    
    	
###### EXPLORE THE DATA TAB
      
      
      
    tabPanel("Data exploration/Self Service",
      
  #### HEAD      
      
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "navbar_th.css"),
        HTML('<style>
          .cnavside {padding-top: 50px; width:50px; height:100%; float:left; position: fixed; top:0; background-color: rgba(0, 39, 76, 1); border: 5px  solid;}
          .cnavsider {padding-right: 10px; padding-left: 10px; padding-top: 50px; width:300px; height:100%; float:right; position: fixed; top:0; right:0; background-color: rgba(230, 240, 245, 0.5); border: 5px rgba(230, 240, 245, 0.5);}
          .content {margin-left: 50px; margin-top: 0px; padding-top: 20px;}
          .tabHead {margin-bottom: 10px; margin-top: 0px;padding-left: 10px; padding-bottom: 10px;}
          .ytext {color: rgba(255, 203, 5, 1);}
          .box2 {padding-bottom:3px;margin-top:10px}
          .box2_h {height:325px}
        </style>'),
        includeHTML("graph.js")
      ),
      
  #### LEFT SIDE BAR
#      HTML('<div id="navside" class="cnavside">
#        <a href="#"  class="ytext">Table</a><br>
#        <br class="br2">
#        <a href="#last" class="ytext">Map</a><br>
#        </div>'),
      HTML('<div id="navside" class="cnavside">
            </div>'),
      
  #### RIGHT SIDE BAR
      HTML('<div id="navsider" class="cnavsider">'),
        sliderInput("ageslider", label = "Age", min = 10, max = 90, value = c(10, 90)),
        sliderInput("cscoreslider", label = "Credit Score", min = 350, max = 850, step=50, value = c(350, 850)),
        sliderInput("nprodslider", label = "Number of acquired products", min = 1, max = 6, value = c(1, 6)),
        selectInput('prodhasselect', 'Holding Products', c('Checking', 'MMA', 'Credit Card', 'Mortgage', 'Heloc', 'Student Loan'), multiple=TRUE, selectize=TRUE),
        selectInput('nboselect', 'Recomended Products', c('Checking', 'MMA', 'Credit Card', 'Mortgage', 'Heloc', 'Student Loan'), multiple=TRUE, selectize=TRUE),
        selectInput('hassocacc', 'Use social networks', c('Any', 'Yes', 'No'), multiple=FALSE, selectize=TRUE),
		selectInput('lookingforhouse', 'Interested in home improvement or buying a home', c('Any', 'No', 'In last month', 'In last 3 months', 'In last 6 months', 'In last 12 months'), multiple=FALSE, selectize=TRUE),
        selectInput('dnclist', 'Do Not Contact List', c('Any', 'Yes', 'No'), multiple=FALSE, selectize=TRUE),
				actionButton('updatefltr', 'Update Marketing Segments'),
      HTML('</div>'),
      
      
  #### BODY
      HTML('<div style="margin-top: 20px"></div>'),
      HTML('<div class="content">'),
      h3(height="15px", class="tabHead", "Explore the Data"),

      column(width=9,
        div(class = 'box',
          reactiveHTML2()
        )
      ),
      
      
    ## MAP
      
      column(width=4,
        div(class = 'box',
          height = '600px',
#          h1('Map'),
          reactiveMap(outputId = "mapplot"),
          verbatimTextOutput('results')
        )
      ),
      
      
    ## CP BAR CHART
      
      column(width=5,
        div(class = 'box',
#			plotOutput("transactional_scatterplot")
          height = '600px',
          reactiveCLTVBar()
        )
      ),
			
      column(width=5,
        div(class = 'box',
#			plotOutput("behavioural_scatterplot")
          height = '600px',
          reactiveCLTVChart()
        )
      ),
      
      
      HTML('</div>') # content
    ),
	
	
	
	
#    tabPanel("Loyalty programs",
#		div(style='margin-top:60px'),
#		h2("Loyalty Programs"),
#		column(3,
#			div(class = 'box box2',
#				plotOutput('loyal1'),
#				h5('Complaint topic'),
#				plotOutput('loyalp1', height = 170),
#				h5('Feedback samples'),
#				htmlOutput('loyalcom1')
#			)
#		),
#		column(3,
#			div(class = 'box box2',
#				plotOutput('loyal2'),
#				h5('Complaint topic'),
#				plotOutput('loyalp2', height = 170),
#				h5('Feedback samples'),
#				htmlOutput('loyalcom2')
#			)
#		),
#		column(3,
#			div(class = 'box box2',
#				plotOutput('loyal3'),
#				h5('Complaint topic'),
#				plotOutput('loyalp3', height = 170),
#				h5('Feedback samples'),
#				htmlOutput('loyalcom3')				
#			)
#		),
#		column(3,
#			div(class = 'box box2',
#				plotOutput('loyal4'),
#				h5('Complaint topic'),
#				plotOutput('loyalp4', height = 170),
#				h5('Feedback samples'),
#				htmlOutput('loyalcom4')
#			)
#		)
#	),
	
	
    
###### 360 CUSTOMER VIEW
      
    
    tabPanel("The 720 view of the Customer",
      HTML('<div style="margin-top: 20px"></div>'),

      column(width=8,
        column(width=6,
          div(class = 'box box2',
            height = '100px',
            numericInput("csd_custId", "Enter Customer Number:",
                           min = 0, max = 1000000, value = 0, step = 1)
          ),
          div(class = 'box box2 box2_h',
            imageOutput("myImage")),
		  div(class = 'box',
			h4('Customer Interaction History'),
            reactiveHTML()
          )
        ),
        column(6,
          div(class = 'box box2',
			h4('Customers Profile'),
            HTML(paste('
              <style type="text/css">
              .tg  {border-collapse:collapse;border-spacing:0;}
              .tg td{font-family:Arial, sans-serif;font-size:12px;padding:2px 2px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
              .tg th{font-family:Arial, sans-serif;font-size:12px;font-weight:normal;padding:2px 2px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
              .tg .tg-ek65{background-color:#ffffff;color:#000000}
              .tg .tg-bsv2{background-color:#efefef}
              .tg .tg-bsv3{background-color:#8CFA64}
              </style>
              <table width = 100% class="tg">
                <tr>
                  <th class="tg-ek65">Customer Name</th>
                  <th class="tg-bsv2">',textOutput('t_customer_name'),'</th>
                </tr>
                <tr>
                  <th class="tg-ek65">Customer Segment</th>
                  <th class="tg-bsv2">',textOutput('t_customer_segment'),'</th>
                </tr>
                <tr>
                  <th class="tg-bsv3">Investable Asset Estimate</th>
                  <th class="tg-bsv3">',textOutput('t_IAE'),'</th>
                </tr>
                <tr>
                  <th class="tg-bsv3">Credit Score - FICO</th>
                  <th class="tg-bsv3">',textOutput('t_csc'),'</th>
                </tr>
                <tr>
                  <th class="tg-ek65">Customer Address</th>
                  <th class="tg-bsv2">',textOutput('t_addr'),'</th>
                </tr>
                <tr>
                  <th class="tg-ek65">Customer Email</th>
                  <th class="tg-bsv2">',textOutput('t_email'),'</th>
                </tr>
                <tr>
                  <th class="tg-ek65">Customer Telephone</th>
                  <th class="tg-bsv2">',textOutput('t_ph'),'</th>
                </tr>
                <tr>
                  <th class="tg-ek65">Status</th>
                  <th class="tg-bsv2">',textOutput('t_mar'),'</th>
                </tr>
                <tr>
                  <th class="tg-ek65"># of Children in Home</th>
                  <th class="tg-bsv2">',textOutput('t_nch'),'</th>
                </tr>
                <tr>
                  <th class="tg-bsv3">Zillow Home Value Estimation</th>
                  <th class="tg-bsv3">',textOutput('t_zill'),'</th>
                </tr>
                <tr>
                  <th class="tg-ek65">Home Equity Estimate</th>
                  <th class="tg-bsv2">',textOutput('t_ehe'),'</th>
                </tr>
                <tr>
                  <th class="tg-bsv3">Has social networks account</th>
                  <th class="tg-bsv3">',textOutput('t_soc_net_acc'),'</th>
                </tr>
                <tr>
                  <th class="tg-bsv3">Interest in home improvement</th>
                  <th class="tg-bsv3">',textOutput('t_home_improvement'),'</th>
                </tr>
              </table>'))
          ),
          div(class = 'box',
			h4('Relationship with Bank'),
            HTML(paste('
              <style type="text/css">
              .tg  {border-collapse:collapse;border-spacing:0;}
              .tg .tg-ly0g{font-weight:bold;background-color:#ffffff;text-align:center}
              .tg .tg-2ro4{font-weight:bold;background-color:#ffffff;color:#000000;text-align:center}
              .tg .tg-6997{background-color:#ffffff;color:#000000;text-align:center}
              .tg .tg-j4kc{background-color:#efefef;text-align:center}
              </style>
              <table class="tg" width=100%>
                <tr>
                  <th class="tg-2ro4">Products</th>
                  <th class="tg-ly0g">Products Owned</th>
                  <th class="tg-ly0g">Balance</th>
                </tr>
                <tr>
                  <td class="tg-6997">Checking</td>
                  <td class="tg-j4kc">',textOutput('t_check_o'),'</td>
                  <td class="tg-j4kc">',textOutput('t_check_b'),'</td>
                </tr>
                <tr>
                  <td class="tg-6997">MMA</td>
                  <td class="tg-j4kc">',textOutput('t_mma_o'),'</td>
                  <td class="tg-j4kc">',textOutput('t_mma_b'),'</td>
                </tr>
                <tr>
                  <td class="tg-6997">Credit Card</td>
                  <td class="tg-j4kc">',textOutput('t_cc_o'),'</td>
                  <td class="tg-j4kc">',textOutput('t_cc_b'),'</td>
                </tr>
                <tr>
                  <td class="tg-6997">Mortgage</td>
                  <td class="tg-j4kc">',textOutput('t_mort_o'),'</td>
                  <td class="tg-j4kc">',textOutput('t_mort_b'),'</td>
                </tr>
                <tr>
                  <td class="tg-6997">Heloc</td>
                  <td class="tg-j4kc">',textOutput('t_heloc_o'),'</td>
                  <td class="tg-j4kc">',textOutput('t_heloc_b'),'</td>
                </tr>
                <tr>
                  <td class="tg-6997">Student Loan</td>
                  <td class="tg-j4kc">',textOutput('t_stl_o'),'</td>
                  <td class="tg-j4kc">',textOutput('t_stl_b'),'</td>
                </tr>
              </table>'))
          )
        ),
        column(4,
          div(class = 'box',
            textInput('newMessage', 'Enter Conversation Summary')
          )
        )        
      ),
      column(width=4,
        div(class = 'box boxpanel',
			h4('Life Events'),
          column(6,
            selectInput("csd_mar", "Marital Status",
              choices = c("No changes", "Got married", "Divorced")),
            selectInput("csd_ch", "Having a Baby",
              choices = c("No changes", "New Baby")),
            selectInput("csd_job", "Job changes",
              choices = c("No changes", "New job", "Lost job")),
            selectInput("csd_bh", "Buying a home",
              choices = c("No changes", "Bought a home"))),
          column(6,
            selectInput("csd_ch_age", "Child going to college",
              choices = c("No changes", "Child goes to college")),
            selectInput("csd_ch_age2", "Child getting married",
              choices = c("No changes", "Child is getting married")),
            selectInput("csd_ret", "Retiring",
              choices = c("No changes", "Retiring")),
            selectInput("home_empr", "Home Improvement",
              choices = c("No", "Yes")))
        ),
        div(class = 'box boxpanel2',
		  h4('Customer engagement'),
          HTML(paste('
            <style type="text/css">
            .tg2  {border-collapse:collapse;border-spacing:0;}
            .tg2 td{font-family:Arial, sans-serif;font-size:12px;padding:2px 2px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
            .tg2 th{font-family:Arial, sans-serif;font-size:12px;font-weight:normal;padding:2px 2px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color : white;}
            .tg2 .tg-ek66{background-color:#bfdfef;color:#000000}
            .tg2 .tg-bsv4{background-color:#cfefef}
            </style>
            <table width = 100% class="tg2">
              <col width="50%">
              <col width="50%">
              <tr>
                <th class="tg-ek66">Current Profitability</th>
                <th class="tg-bsv4">',textOutput('t_cp'),'</th>
              </tr>
              <tr>
                <th class="tg-ek66">CLTV</th>
                <th class="tg-bsv4">',textOutput('t_cltv'),'</th>
              </tr>
              <tr>
                <th class="tg-ek66">Revised CLTV</th>
                <th class="tg-bsv4">',textOutput('t_cltv_rev'),'</th>
              </tr>
              <tr>
                <th class="tg-ek66">Current NBO-R</th>
                <th class="tg-bsv4">',textOutput('t_nbo_sale'),'</th>
              </tr>
              <tr>
                <th class="tg-ek66">Revised NBO-R</th>
                <th class="tg-bsv4">',textOutput('t_nbo_rev'),'</th>
              </tr>
            </table>')
          )
        ),
        actionButton('updateBtn', 'Update recommendation')
      )
    ),
    
	

	
	
	
	
	
	
    tabPanel("Client List Generation",
      HTML('<div style="margin-top: 40px"></div>'),
      column(10,offset=1,
        h1(class="h1_c",'Campaign Target Customer List Generation'),
        dataTableOutput('camp_client_list'),
        actionButton('updateBtnccl', 'Refresh Data'),
        br(),
        HTML('<button class="offset1 btn btn-default" onclick="myFunction()">Execute campaign</button>
        <script>
          function myFunction() {
            alert("Campaign executed.");
        }
        </script>')
      )
    ),
	
	
    tabPanel("Sentiment Analysis",
      HTML('<div style="margin-top: 40px"></div>'),
      column(8,offset=1,
        reactiveTexta()
      ),
      column(1,
        br(),
        br(),
        br(),
        actionButton('getMess', 'Get new message')
      )
    )
    
    # tabPanel("Social Networks Monitoring",
      # HTML('<div style="margin-top: 100px"></div>'),
      # column(width=8, offset=2,
        # div(class = 'box',
          # reactiveHTML_social()
        # )
      # ),
      # column(width=2,
        # actionButton('updateBtn_social', 'Refresh Data')
      # )
    # ),

  )
)

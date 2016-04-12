a01_segmentation <- tabPanel("Segmentation",fluidRow(
  column(3,
	box(tagList(
	 h3("Parameters"),
	 htmlOutput('parameters')
	))),
  column(6,
	box(tagList(
	  h3("Plot"),
	  tabsetPanel(
		tabPanel("Transaction",
  		plotOutput("scatterplot_tr"),
  		plotOutput("barplot_tr")),
	  tabPanel("Behavior",
  		plotOutput("scatterplot_bh"),
  		plotOutput("barplot_bh"))
	  )
	))
  ),
  column(3,
	box(tagList(
	 h3("Filters"),
	 sliderInput("sel_age", label = "Age", min = 20, max = 60, value = c(10, 90)),
	 selectInput('sel_state', 'State', state.name, multiple=TRUE, selectize=TRUE),
	 selectInput('sel_sex', 'Sex', c('Any', 'Male', 'Female'), multiple=FALSE, selectize=TRUE),
	 selectInput('sel_dnc', 'Do Not Contact List', c('Any', 'Yes', 'No'), multiple=FALSE, selectize=TRUE),
	 actionButton('updatefltr', 'Apply filters', style='background-color:#428bca; color:#fff')
	),"position: fixed; width:24%; height:85%;right: 0px;background-color:#cceeff")
  )
))
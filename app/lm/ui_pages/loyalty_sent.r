a04_loyalty_sent <- tabPanel("Performance",
	div(style='margin-top:10px'),
	h2("Loyalty Programs"),
	column(3,
		box(tagList(
			plotOutput('loyal1'),
			h5('Complaint topic'),
			plotOutput('loyalp1', height = 170),
			h5('Feedback samples'),
			div(
			  style="font-size:85%; max-height: 500px; overflow-y: auto;",
  			htmlOutput('loyalcom1')
			)
		))
	),
	column(3,
		box(tagList(
			plotOutput('loyal2'),
			h5('Complaint topic'),
			plotOutput('loyalp2', height = 170),
			h5('Feedback samples'),
			div(
			  style="font-size:85%; max-height: 500px; overflow-y: auto;",
			  htmlOutput('loyalcom2')
			)
		))
	),
	column(3,
		box(tagList(
			plotOutput('loyal3'),
			h5('Complaint topic'),
			plotOutput('loyalp3', height = 170),
			h5('Feedback samples'),
			div(
			  style="font-size:85%; max-height: 500px; overflow-y: auto;",
			  htmlOutput('loyalcom3')
			)
		))
	),
	column(3,
		box(tagList(
			plotOutput('loyal4'),
			h5('Complaint topic'),
			plotOutput('loyalp4', height = 170),
			h5('Feedback samples'),
			div(
			  style="font-size:85%; max-height: 500px; overflow-y: auto;",
			  htmlOutput('loyalcom4')
			)
		))
	)
)
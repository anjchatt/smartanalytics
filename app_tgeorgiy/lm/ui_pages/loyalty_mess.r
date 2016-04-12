a02_loyalty_mess <- tabPanel("Loyalty programs",
	{t <- readLines('ui_pages/loyalty_mess.html')
	HTML(paste0(t,collapse='\n'))}
)

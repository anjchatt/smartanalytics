library(ggplot2)

fbmessages_loyalty <- list(CapCash=c("I love the CapCash Visa Signature Credit Card! What I like most is that it lets me pick my categories that I earn 5% and 2% cash back on, plus I earn 1% cash back on everything else. I get to pick from a set list which has tons of useful things to pick from such as restaurants, furniture stores, and even my phone bill. I like to save my rewards to get my cash back and use it for vacations. It is from my own bank so I can trust it and can deposit my rewards straight into my checking account. Overall, it is my favorite credit card I've ever used.",
                "The CapCash Signature Credit Card is phenomenal!!! My wife and I have had this card for about a year and we absolutely love it. The interest rates are very good, there is no annual fee, and you don't have a rewards limit to what you can earn. Having the ability to earn 1% on everything, 2% on gas, groceries, or drug stores, and 5% back on restaurants or department stores. The greatest thing I love about this card is that if you have a US Bank checking or savings account, you can make payments that immediately increase your available funds, which makes using it for stuff you would be purchasing with a debit card a perfect substitution. I wouldn't use anything else!",
                "I transferred a balance to this card when I received an offer for 18 months interest free. Since I'm trying to pay off my debt, it seemed like a good deal that would save me a little money. They've been pretty good to me and it is easy to make payments (which is a big deal for me - don't make it hard to take my money...). I like the iphone app too; which allows me to make a payment when I'm away from my computer. That's super helpful. I have never had a reason to call them - so I can't speak knowledgeably about their customer service; but perhaps that says enough: I've never had to call them..",
                "The cash rewards Visa card has been my card since early in college. It has worked well over the last 8 years or so and I am always happy to find a reward waiting for me since I use the card a lot for daily and weekly things like groceries and gas. If you are in school or just out this is a great card to get you started and it's tied to US Bank so you can even manage it online along with your checking and savings accounts.Ita??s not the most amazing card ever, but ita??s a solid card for new card holders.",
                "I have been using this for several years and I have had a great experience with my CapCash & Visa Signature card. The website allows easy online payment, and user-friendly while aesthetically pleasing views to manage your spending. Interest rates are low with great rewards/bonuses. In addition to being a great credit card, this company has an extremely helpful, knowledgeable and friendly customer service team."),
  CapFreedom=c("AWESOME CARD!! Used this card for my vacation and just on GAS this summer I earned $75 cashback!! You earn cashback MUCH quicker than one would think..  Also, their customer service is amazing! Overall I am very happy with my freedom card",
               "I'm on hold to report fraud on the account that I've had for 23 years. Using the number your customer service rep gave me (877-366-1121). I dialed at 1:52 p.m. As of 2:15 p.m., I'm still on hold, waiting to speak to a representative. This is not the first time I've called. The first time, I waited on hold for 20 minutes without ever speaking to a representative. I hung up because I had somewhere else to be. This time, it's been 23 minutes.",
			   "Between the $100 signup bonus, the 0% APR promotion, and 5% cash back on rotating categories (which are all places I use, like Starbucks, gas stations, restaurants, etc.), this is a great overall card.", 
               "The Freedom card has a set of rotating categories where you can get 5% cash back. I benefit the most from using it for gas, groceries and shopping on Amazon (also good for Starbucks and movie theaters, where I probably spend more than most folks). This card is great when you pair it with the Chase Sapphire Preferred as you can combine reward points between the two.",
               "The card does not carry a lot of rewards but it is a low interest card.",
               "I like the card very much. I get 5% cash back on something different every quarter, and I can use that cash back directly on Amazon if I so choose. Or I can apply it as a credit regardless of the amount. Have not really had to deal with customer service too much, but the two times I called, my issue was resolved quickly.",
               "The low intro APR was pretty key for me. On top of that, the no annual fee 1% unlimited cash back have made this credit card much more valuable to me in the long run than my previous cards. This chase credit card really gives me the \"freedom\" to spend how I want and not have to worry about crazy fees on cash back or ridiculous APR. ",
               "The $100 bonus was great too and very easy to qualify for. If I had to recommend a credit card for people my age who are responsible but love getting 5% cash back for spending in grocery stores and target type stores I would definitely recommend the Chase Freedom Card",
               "My credit card ia a great card and it gives me great benefits. Whenever i lose it, i am able to get a new one right that same day. Every year, i am able to get some cash back if i make my payments on time. My card is thick and it's really hard for it to fall out of my wallet . My card also gets benefits at certain restaurants, and am able to get discounts in some restaurants."),
  CapRewards=c("The card is pretty good. The benefits have declined over time which allows you to negotiate the fee down to $0",
               "It took me 3 weeks to hear from them then they sent me a letter to confirm my SSN and I missed my tuition because all credit cards I have had took me less than 1 week to be approved but the citi bank is awful. Also customer service is horrible they do not even answer you and if they answer the do not do anything to solve the problem, even I talk to manager and she told I am sorry I cant do anything. I highly recommend you never apply for any of cap bank credit cards they annoy you alot to be approved also after approved nothing is clear about the rewards and cashback and redemption. Never Never recommend citi",
			   "With my CapRewards Premier card I get points for purchasing everyday items like gas and groceries that I can use to get rewards like giftcards or travel; but I can also use my points to purchase things on Amazon. I get emails which allow me to buy tickets to shows before anyone else has the opportunity to; and they also check to see if a purchase I made was cheaper elsewhere and I get the difference. There are many benefits to using the CapBank ThankYou Premier card. These are just the few that I use. They offer concierge service, car rental insurance and are flexible with your spending limit.",
               "Good card. Accepted everywhere. Never had a problem.",
               "This is my absolute favorite card that I have. A lot of cards now are charging annual fees which really hurt if you're not using the card very often. Not with this card though there's no annual fee. The customer service with this card is amazing. I received a e-mail and text alert notifying me that someone was trying to use my card for an online purchase at Staples. Chase recognized that it wasn't me and immediately stopped the transaction. Speaking to customer care was easy and they got me out a brand new card within a week. A+ on the CapRewards Card!",
               "This card has a good cashback rate and gives thank you points which you can use to redeem. There is no annual fee and the APR isn't high. This card also comes with a reasonable credit line.It can be used almost anywhere to buy anything."),
  CapTravel=c("This is a great card. I get 1.65% back. I use Sallie Mae MC for gas, grocery and amazon and everything else goes on this BoA travel card. I know that I can use Citi double cash instead but I like the fact that I can redeem for travel expenses. Feels like a gift :) I don't use cards with annual fees and not into churning and collecting miles.",
              "I am DONE with CapBank. As soon as I can I am withdrawing everything and changing banks because you constantly make it difficult to use my own money!",
			  "I would recommend this card anyone who has account with CapBank and want an everyday use card.",
              "We were traveling in South America last week. We were stunned, and a little embarrassed as US citizens, that our ATM cards don't work in most ATMs there. They have moved on to using chipped cards and most banks won't accept a magnetic strip card. When will Capbank issue chipped debit cards that travelers can use in other countries? This is kind of ridiculous for the US to be this far behind.",
			  "if we are going to be travelling out of the country should we notify our bank. What the hell!?",
			  "I took a trip to Florida last summer and I have used this card to redeem points for my flight and hotel. It was very slow and hard to be used and best of all I earn 1 points for per 1 dollars on the purchases that I have made on the trip. I would highly recommend this card if you are traveling.",
              "The \"travel\" is very broadly defined by CapBank, so the reward points are easy to use and can be used to pay part of a travel cost.",
              "This card was my life blood when I was traveling and living abroad. With the EMV chip It was accepted everywhere from Morocco to Poland, England and more. The fees are low and the rewards program is on point. I was able to accumulate enough points to earn a free flight within the first three months, very useful for the frequent traveler.",
              "Customer service was great and my card was promptly replaced when I returned to the US.",
              "I really like this card because it is easy to use internationally for multiple reasons including that it has a chip. Most of my cards are Visa and I enjoy diversifying my wallet with a MasterCard. I travel a lot so travel rewards are important to me, and you do not have to pay a yearly fee, which is really ideal for me. I have not had an issue with this card to date.",
              "I really have enjoyed my experience with capBank especially their Travel Rewards Card. I have been a loyal BofA patron for over 12 years and had their Alaskan Airlines CC until it was discontinued last year. I then switched over to their traveler rewards card. Not only do I earn free miles on certain airlines but I also can earn point towards other travel expense. This is a perfect card for someone who is a frequent traveler.",
              "With the Capbank travel rewards card I have the power of traveling anywhere in this world and not pay any fees at all. No foreign transaction fees at all. I love this card It provides me with the security I need in order to feel safe when using my credit card. I love the fact that for the 1st year I don't pay any interest on any purchases I make. For the lifetime of the credit card I dont pay an annual fee for the use of the credit card.I am going to aruba in march of this year and I am going to using this card for all my purchases because I won't be getting any fees with this card and on top of all this I get 1.5 points for all my purchases I make with this card.")
  )

loaylcom_sent<-list(
	c(0.8,0.85,0.83,0.75,0.78)*2-1,
	c(0.87,0.1,0.6,0.75,0.55)*2-1,
	c(0.75,0.54,0.07,0.75,0.9)*2-1,
	c(0.71,0.25,0.58,0.25,0.31)*2-1
)

output$loyal1 <- renderPlot({
#	palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
#		  "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
loyalty_programs <- c('CapCash', 'CapFreedom', 'CapRewards', 'CapTravel')
pos_sentiments <- c(0.91,0.57,0.74,0.21)
lbls <- c('positive', 'negative')
id <- 1
slice <- c(pos_sentiments[id], 1-pos_sentiments[id])
p<-pie(slice, labels = paste0(lbls, ' ', slice*100, '%'), main=loyalty_programs[id], col=c('#118811','#881111'))

#	palette('default')
return(p)
})

output$loyal2 <- renderPlot({
#	palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
#		  "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
loyalty_programs <- c('CapCash', 'CapFreedom', 'CapRewards', 'CapTravel')
pos_sentiments <- c(0.91,0.57,0.74,0.21)
lbls <- c('positive', 'negative')
id <- 2
slice <- c(pos_sentiments[id], 1-pos_sentiments[id])
p<-pie(slice, labels = paste0(lbls, ' ', slice*100, '%'), main=loyalty_programs[id], col=c('#118811','#881111'))

#	palette('default')
return(p)
})

output$loyal3 <- renderPlot({
#	palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
#		  "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
loyalty_programs <- c('CapCash', 'CapFreedom', 'CapRewards', 'CapTravel')
pos_sentiments <- c(0.91,0.57,0.74,0.21)
lbls <- c('positive', 'negative')
id <- 3
slice <- c(pos_sentiments[id], 1-pos_sentiments[id])
p<-pie(slice, labels = paste0(lbls, ' ', slice*100, '%'), main=loyalty_programs[id], col=c('#118811','#881111'))

#	palette('default')
return(p)
})

output$loyal4 <- renderPlot({
#	palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
#		  "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
loyalty_programs <- c('CapCash', 'CapFreedom', 'CapRewards', 'CapTravel')
pos_sentiments <- c(0.91,0.57,0.74,0.21)
lbls <- c('positive', 'negative')
id <- 4
slice <- c(pos_sentiments[id], 1-pos_sentiments[id])
p<-pie(slice, labels = paste0(lbls, ' ', slice*100, '%'), main=loyalty_programs[id], col=c('#118811','#881111'))

#	palette('default')
return(p)
})
  
problems_l <- c('1.Terms', '2.Technical', '3.Not actual', '4.Other')
problems_sc <- list(loyal1=c(0.16,0.094,0.458,0.29),
				loyal2=c(0.36,0.06,0.31,0.27),
				loyal3=c(0.23,0.1,0.07,0.61),
				loyal4=c(0.24,0.36,0.13,0.27))

output$loyalp1 <- renderPlot({x <- problems_l
							  y <- problems_sc$loyal1
							  p <- ggplot(data = data.frame(x=x, y=y),
										aes(x = x, y = y)) + 
									geom_bar(stat = "identity", aes(fill = c('1','2','3','4'))) +
									theme(legend.position="none") + 
									labs(x='',y='')
							  return(p)},
							 height = 170)

output$loyalp2 <- renderPlot({x <- problems_l
							  y <- problems_sc$loyal2
							  p <- ggplot(data = data.frame(x=x, y=y),
										aes(x = x, y = y)) + 
									geom_bar(stat = "identity", aes(fill = c('1','2','3','4'))) +
									theme(legend.position="none") + 
									labs(x='',y='')
							  return(p)},							  
							 height = 170)
							 
output$loyalp3 <- renderPlot({x <- problems_l
							  y <- problems_sc$loyal3
							  p <- ggplot(data = data.frame(x=x, y=y),
										aes(x = x, y = y)) + 
									geom_bar(stat = "identity", aes(fill = c('1','2','3','4'))) +
									theme(legend.position="none") + 
									labs(x='',y='')
							  return(p)},
							 height = 170)
							 
output$loyalp4 <- renderPlot({x <- problems_l
							  y <- problems_sc$loyal4
							  p <- ggplot(data = data.frame(x=x, y=y),
										aes(x = x, y = y)) + 
									geom_bar(stat = "identity", aes(fill = c('1','2','3','4'))) +
									theme(legend.position="none") + 
									labs(x='',y='')
							  return(p)},
							 height = 170)

output$loyalcom1 <- renderUI({
  sentiment <- loaylcom_sent[[1]]
  redCol <- sapply(round(-sentiment*255+255),function(v){min(v,255)})
  yelCol <- sapply(round(sentiment*255+255),function(v){min(v,255)})
  rowstyles <- paste0('style="background-color:rgba(',redCol,',',yelCol,',0,0.5);"')
  
  table_com <- paste0('<style>.td-events{padding:5px}
					 table,th,td{border: 1px solid white;}</style>',
			  '<table cellpadding="10" style="background-color:#dadafa;margin-top:10px;font-size:100%">',
			  paste0('<tr ',rowstyles,'><td class=td-events>',fbmessages_loyalty[[1]],'</td></tr>',
					 collapse=''),
			  "</table>",collapse='')
  return(HTML(table_com))
})

output$loyalcom2 <- renderUI({
  sentiment <- loaylcom_sent[[2]]
  redCol <- sapply(round(-sentiment*255+255),function(v){min(v,255)})
  yelCol <- sapply(round(sentiment*255+255),function(v){min(v,255)})
  rowstyles <- paste0('style="background-color:rgba(',redCol,',',yelCol,',0,0.5);"')
  
  table_com <- paste0('<style>.td-events{padding:5px}
					 table,th,td{border: 1px solid white;}</style>',
			  '<table cellpadding="10" style="background-color:#dadafa;margin-top:10px;font-size:100%">',
			  paste0('<tr ',rowstyles,'><td class=td-events>',fbmessages_loyalty[[2]][1:5],'</td></tr>',
					 collapse=''),
			  "</table>",collapse='')
  return(HTML(table_com))
})

output$loyalcom3 <- renderUI({
  sentiment <- loaylcom_sent[[3]]
  redCol <- sapply(round(-sentiment*255+255),function(v){min(v,255)})
  yelCol <- sapply(round(sentiment*255+255),function(v){min(v,255)})
  rowstyles <- paste0('style="background-color:rgba(',redCol,',',yelCol,',0,0.5);"')
  
  table_com <- paste0('<style>.td-events{padding:5px}
					 table,th,td{border: 1px solid white;}</style>',
			  '<table cellpadding="10" style="background-color:#dadafa;margin-top:10px;font-size:100%">',
			  paste0('<tr ',rowstyles,'><td class=td-events>',fbmessages_loyalty[[3]][1:5],'</td></tr>',
					 collapse=''),
			  "</table>",collapse='')
  return(HTML(table_com))
})

output$loyalcom4 <- renderUI({
  sentiment <- loaylcom_sent[[4]]
  redCol <- sapply(round(-sentiment*255+255),function(v){min(v,255)})
  yelCol <- sapply(round(sentiment*255+255),function(v){min(v,255)})
  rowstyles <- paste0('style="background-color:rgba(',redCol,',',yelCol,',0,0.5);"')
  
  table_com <- paste0('<style>.td-events{padding:5px}
					 table,th,td{border: 1px solid white;}</style>',
			  '<table cellpadding="10" style="background-color:#dadafa;margin-top:10px;font-size:100%">',
			  paste0('<tr ',rowstyles,'><td class=td-events>',fbmessages_loyalty[[4]][1:5],'</td></tr>',
					 collapse=''),
			  "</table>",collapse='')
  return(HTML(table_com))
})
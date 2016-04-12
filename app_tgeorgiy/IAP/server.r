## GLOBAL

library(RMongo)
library(rPython)
library(data.table)
library(ggplot2)

mongo <- mongoDbConnect("cdb", "localhost", 27017)
st = data.frame(id=c(25,  9, 36, 42, 34, 10, 24, 51, 37, 45, 13, 12),
                name=c("MA", "CT", "NY", "PA", "NJ", "DE", "MD", "VA", "NC", "SC", "GA", "FL"))
segment_v <- 1:5
prods <- c("Checking","MM","Mortgage","Home_eq","CC","StLoan")
prods_names <- c('Checking', 'MMA', 'Mortgage', 'Heloc', 'Credit Card', 'Student Loan')
segs <- c('Mass Market', 'Young Prorfessional', 'Mass Affluent', 'Affluent', 'High Net Worth')
marstat <- c('Married', 'Not Married')

message_data <- c()
message_data$text <- c('I am still not receiving my bank statements electronically even though I selected that option 2 months ago.  What is wrong with you people? Please make sure this issue is resolved before I receive my April Statement.  Thanks',
                      'I have to say that I really love the online banking feature on the bank website.  It is so easy to add payees and pay my bills.  It used to take me a good part of Saturday afternoons to pay my bills and then go to the post office.  Now I pay my bills in 15 minutes for the week.  Great job and keep great services like this coming :)',
                      'I went to the Elm Street branch on Saturday as I often do and the branch was closed.  I saw the branch open hours on the door says "Saturday - Closed" .  It would have been nice to have let the customers that use this branch know about this change for Saturdays.   You need to do a better job keeping your customers informed.  Very disappointing.',
                      "What is the bank's policy on making deposits available for use?  Sometimes my total deposit amount is available immediately, other times only part of the deposit is available right away.  Is it based on the amount of the deposit?  Please let me know.  Thanks",
                      'I wanted to let you know that Jane Smith at the Main Street Branch did a great job yesterday helping me with my problem.   I had lost my ATM card and need to travel out of town this evening.  Jane was able to get a new ATM Card sent overnight and it arrived this afternoon.  I can now leave for my trip with my trusty ATM Card.  Great job by Jane.  Please let her Branch Manager know he is lucky to have her.',
                      'How can I link my HELOC to my checking account?  I got my first HELOC statement and I had to go to the branch to make my payment.  It will be a lot more convenient to just make the payments online from my checking account.  Please let me know.  Thanks',
                      "I can't believe what the bank did to me.  I went to the branch on Tuesday specifically to make  deposit in my checking account to cover my Mortgage Payment that is auto-deducted from my account on Wednesday.  Somehow the bank did not post the deposit.  So on Wednesday night I get an email from the bank stating insufficient funds for my mortgage payment.  On top of that, I wrote 3 checks knowing I had the funds to cover them.  I am sure they will now bounce.  This will be extremely embarrassing to me.   I can't believe how incompetent your bank is.  I am really pissed.   I am probably going to close all my accounts and take my business to a bank that knows what the hell they are doing.  You guys are the worse!!!!")
message_data$cust_number <- c(111111, 111222, 111333, 111444, 111555, 111666, 222222)
message_data$cat <- c("Complaint", "Complement", "Complaint", "Question", "Complement", "Question", "Code Red Complaint")
message_data$sent <- c("Disappointed", "Happy", "Disappointed", "Neutral", "Happy", "Neutral", "Very Angry")
message_data$cltv <- c('$ 840', '$ 1,090', '$ 3,000', '$ 900', '$ 6,200', '$ 270', '$ 6,000')
message_data$acp <- c('$ 150', '$ 225', '$ 375', '$ 125', '$ 910', '$ 290', '$ 700')

message_data <- data.frame(message_data, stringsAsFactors=F)

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
  
conversation_history <- data.frame(time=c('03/20/2015', '02/14/2015', '02/01/2015', '16/01/2015', '02/12/2015'),
                                    message=c('Discussion with BPR 14 regarding opening $50K HELOC', 'Discussed January Credit Card Statement with CC CSR', 'Br 14 Teller Visit to put a stop payment on a check', 'Discussed with Mortgage CSR, when his ARM will reset for 2015', 'Upset he did not receive his checking account Statement via email as he had requested'),
                                    source=c('Branch 007','CC CSR Call Center','Teller 125 Branch 007', 'Mortgage CSR Call Center', 'Bank Website Chat'), 
                                    cat=c('Sales Opportunity','Question','Transaction Request', 'Question','Complaint'),
                                    sent=c('Happy','Happy','Neutral', 'Happy', 'Unhappy'),
                                    stringsAsFactors=F)
conversation_history_mad <- data.frame(time=c('03/20/2015', '03/20/2015', '02/27/2015', '01/31/2015'),
                                      message = c("Spoke to Customer about Code Red situation.  Promised to personally address Mortgage issue and credit funds to cover checks.  Offered him free no-bounce protection for his checking account, and issued him a $200 credit to his checking account for the pain he suffered.  He admitted he was impressed with our problem resolution approach and if all the problems are actually resolved, he will re-think leaving the bank.  We are not out of the woods yet, but I believe we will retain the customer",
											  "I can't believe what the bank did to me.  I went to the branch on Tuesday specifically to make  deposit in my checking account to cover my Mortgage Payment that is auto-deducted from my account on Wednesday.  Somehow the bank did not post the deposit.  So on Wednesday night I get an email from the bank stating insufficient funds for my mortgage payment.  On top of that, I wrote 3 checks knowing I had the funds to cover them.  I am sure they will now bounce.  This will be extremely embarrassing to me.   I can't believe how incompetent your bank is.  I am really pissed.   I am probably going to close all my accounts and take my business to a bank that knows what the hell they are doing.  You guys are the worse!!!!",
                                              "Discussed January Mortgage Statement with Mortgage CSR",
                                              "Will my 1099 forms be delivered by email or mail this year?"),
                                      source=c('Branch 007', 'Branch 007','Mortgage CSR Call Center','CSR Call Center'),
                                      cat=c('Problem Resolution', 'Code Red Complaint','Question','Question'),
                                      sent=c('Neutral','Very Angry','Neutral','Neutral'),
                                      stringsAsFactors=F)
conversation_history <- apply(t(as.matrix(conversation_history)),2, as.list)
conversation_history_mad <- apply(t(as.matrix(conversation_history_mad)),2, as.list)
conversation_history_header = c('time', 'message', 'source', 'sent')

# scatterplot
scatterplot_data <- read.csv("data10000_.csv", header = TRUE)
#scatterplot_data <- dbGetQueryForKeys(mongo,'arr','','{segments:1, method_mobile:1, method_webbank:1, dest_tech:1, dest_online:1}',0,10000)



clean_tables <- function(output, session){
  output$t_customer_name <- renderText('-')
  output$t_customer_segment <- renderText('-')
  output$t_IAE <- renderText('-')
  output$t_csc <- renderText('-')
  output$t_addr <- renderText('-')
  output$t_email <- renderText('-')
  output$t_ph <- renderText('-')
  output$t_mar <- renderText('-')
  output$t_nch <- renderText('-')
  output$t_zill <- renderText('-')
  output$t_ehe <- renderText('-')
  output$t_soc_net_acc <- renderText('-')
  output$t_home_improvement <- renderText('-')
  output$t_check_o <- renderText('-')
  output$t_check_b <- renderText('-')
  output$t_mma_o <- renderText('-')
  output$t_mma_b <- renderText('-')
  output$t_cc_o <- renderText('-')
  output$t_cc_b <- renderText('-')
  output$t_mort_o <- renderText('-')
  output$t_mort_b <- renderText('-')
  output$t_heloc_o <- renderText('-')
  output$t_heloc_b <- renderText('-')
  output$t_stl_o <- renderText('-')
  output$t_stl_b <- renderText('-')
  output$t_cp <- renderText('-')
  output$t_cltv <- renderText('-')
  output$t_nbo_sale <- renderText('-')
  output$t_nbo_prof <- renderText('-')
  output$t_nbo_rev <- renderText('-')
  
  updateSelectInput(session, "csd_mar", "Marital Status",
                    choices = c("No changes", "Got married", "Divorced"))
  updateSelectInput(session, "csd_ch", "Having a Baby",
                    choices = c("No changes", "New Baby"))
  updateSelectInput(session, "csd_job", "Job changes",
                    choices = c("No changes", "New job", "Lost job"))
  updateSelectInput(session, "csd_bh", "Buying a home",
                    choices = c("No changes", "Bought a home"))
  updateSelectInput(session, "csd_ch_age", "Child going to college",
                    choices = c("No changes", "Child goes to college"))
  updateSelectInput(session, "csd_ch_age2", "Child getting married",
                    choices = c("No changes", "Child is getting married"))
  updateSelectInput(session, "csd_ret", "Retiring",
                    choices = c("No changes", "Retiring"))
  updateSelectInput(session, "home_empr", "Home Improvement",
                    choices = c("No", "Yes"))
  
  tablo <- paste0('
      <style type="text/css">
                    .tg  {border-collapse:collapse;  border-spacing:0;}
                    .tg .tg-ly0g-1 {font-weight:bold;background-color:#ffffff;text-align:center}
                    .tg .tg-j4kc-1{background-color:#efefef;text-align:center}
                    .tg .tg-j4kc-2{background-color:#cfefcf;text-align:center}
                    .tg .tg-j4kc-3{background-color:#ef6f6f;text-align:center}
      </style>
      <table class="tg" width=100%>
                    <tr>
						<th class="tg-ly0g-1">Recent Conversation History</th>
						<th class="tg-ly0g-1">Conversation Summary</th>
						<th class="tg-ly0g-1">Bank Channel</th>
						<th class="tg-ly0g-1">Consumer Sentiment</th>
                    </tr>
	  </table>')
  
  html_p = data.frame(html=tablo)
  session$sendCustomMessage(type='HTML_paste',html_p)
}

#########################################################
# library(shiny)
# require(rCharts)
# library(wordcloud)
# library(devtools)
# library(tm)
# 
# data<- read.csv("/home/biadmin/projects/shiny_app/IAP/LiveChat100Examples.csv")
# a<- table(data$Region,data$Consumer.Sentiment)
# a<-as.data.frame(a)
# # am<<-a[which(a$Var1=="Midwest"),]
# 
# an<<-a[which(a$Var1=="Northeast"),]
# aw<<-a[which(a$Var1=="West"),]
# 
# #Category Analysis
# b<- table(data$Category)
# b<- as.data.frame(b)
# bcomple <- b[which(b$Var1=="Complement"),]
# bcomplaint <- b[which(b$Var1=="Complaint"),]
# bques <- b[which(b$Var1=="Question"),]
#########################################################




shinyServer(function(input, output, session) {

## UPDATE DATA
  aggr_query_flt <- reactive({
    aggr_query <- c()
    input$updatefltr
    
    # GEO filter
    sts <- st$name[st$id %in% input$selstates]
    if (length(sts) != 0){
      filter_str <- paste0(c(' { "$match" : {$or: [ ', paste0('{ State: "', sts, '" }', collapse=","),'] }}'), collapse="")
      aggr_query <- c(aggr_query, filter_str)
    }
    
    # AGE filter
    ageb <- isolate(input$ageslider)
    if ((ageb[1] != 10) || (ageb[2] != 90)){
      filter_str <- paste0(c(' { "$match" : { $and :[{Age: { $gte : ', ageb[1],' }}, {Age: { $lte : ', ageb[2],' }}]}} '), collapse="")
      aggr_query <- c(aggr_query, filter_str)
    }

    # C SCORE filter
    cscb <- isolate(input$cscoreslider)
    if ((cscb[1] != 350) || (cscb[2] != 850)){
      filter_str <- paste0(c(' { "$match" : { $and :[{CreditScore: { $gte : ', cscb[1],' }}, {CreditScore: { $lte : ', cscb[2],' }}]}} '), collapse="")
      aggr_query <- c(aggr_query, filter_str)
    }

    # NPROD filter
    nprodb <- isolate(input$nprodslider)
    if ((nprodb[1] != 1) || (nprodb[2] != 6)){
      filter_str <- paste0(c(' { "$match" : { $and :[{TotalProducts: { $gte : ', nprodb[1],' }}, {TotalProducts: { $lte : ', nprodb[2],' }}]}} '), collapse="")
      aggr_query <- c(aggr_query, filter_str)
    }
    
    # prods filter
    prodhas <- isolate(input$prodhasselect)
    if(length(prodhas)>0){
      filter_str <- '{ "$match" : {$or: [ '
      for(i in 1:length(prodhas)){
        if(i>1){
          filter_str <- paste0(filter_str, ',')
        }
        prod_id <- prods[prods_names %in% prodhas[i]]
        filter_str <- paste0(filter_str, '{', prod_id, ':1}')
      }
      filter_str <- paste0(filter_str,']}} ')
      aggr_query <- c(aggr_query, filter_str)
    }
	
	# NBO filter
    nboprod <- prods[prods_names %in% isolate(input$nboselect)]
    if (length(nboprod) != 0){
      filter_str <- paste0(c(' { "$match" : {$or: [ ', paste0('{ NBO: "', nboprod, '" }', collapse=","),'] }}'), collapse="")
      aggr_query <- c(aggr_query, filter_str)
    }
	
    # SOCACC filter
    hassocacc <- isolate(input$hassocacc)
    if (hassocacc != 'Any'){
	  variants_labels = c('Yes', 'No')
	  variants = c(1, 0)
	  query = variants[variants_labels %in% hassocacc]
      filter_str <- paste0(c(' { "$match" : {has_fb_acc: ',query,'}}'), collapse="")
      aggr_query <- c(aggr_query, filter_str)
    }

#	selectInput('lookingforhouse', 'Interested in home improvement or buying a home', c('Any', 'No', 'In last month', 'In last 3 months', 'In last 6 months', 'In last 12 months'), multiple=FALSE, selectize=TRUE),
	# lookingforhouse filter
    lookingforhouse <- isolate(input$lookingforhouse)
    if (lookingforhouse != 'Any'){
	  variants_labels = c('No', 'In last month', 'In last 3 months', 'In last 6 months', 'In last 12 months')
	  variants = c(0, 1, 3, 6, 12)
	  query = variants[variants_labels %in% lookingforhouse]
	  if (query==0){
		filter_str <- paste0(c(' { "$match" : { "$and": [{looked_for_house: 0}, {has_fb_acc: 1}]}}'), collapse="")
		aggr_query <- c(aggr_query, filter_str)
	  } else {
		filter_str <- paste0(c(' { "$match" : {looked_for_house: { $gt : 0, $lte : ',query,'}}}'), collapse="")
		aggr_query <- c(aggr_query, filter_str)
	  }
    }
	
    # DNC list
    dnc <- isolate(input$dnclist)
    if(dnc!= 'Any'){
      dnc <- ifelse(dnc == 'Yes', 'true', 'false')
      filter_str <- paste0(' { "$match" : {Contact:', dnc, '}}', collapse="")
      aggr_query <- c(aggr_query, filter_str)
    }
    return(aggr_query)
  })
  
  datam_r <- reactive({
    input$updatefltr
    aggr_query <- aggr_query_flt()
#    print(aggr_query)
    
    
    aggr_query <- c(aggr_query,
      paste0(c(' { "$group" : { "_id" : "$Segment",
                                      CP : {$avg : "$TotalCP"},
                                      CLTV : {$avg : "$fp1y_prod"},
                                      depBal : {$avg : "$BalanceDeposit"},
                                      Checking : {$avg : "$Checking"},
                                      MM : {$avg : "$MM"},
                                      Mortgage : {$avg : "$Mortgage"},
                                      Home_eq : {$avg : "$Home_eq"},
                                      CC : {$avg : "$CC"},
                                      StLoan : {$avg : "$StLoan"},
                                      loanBal : {$avg : "$BalanceLoan"},
                                      Xsell : {$avg : "$TotalProducts"},
                                      Age : {$avg : "$Age"},
                                      CreditScore : {$avg : "$CreditScore"},
                                      InvestableAssetIndicator : {$avg : "$InvestableAssetIndicator"},
																			CLTV1Y : {$avg : "$fp1y_prod"},
																			CLTV3Y : {$avg : "$fp3y_prod"},
																			CLTV5Y : {$avg : "$fp5y_prod"},
																			CLTV10Y: {$avg : "$fp10y_prod"},
                                      ', paste0(prods,rep(' : {"$avg" : "$',6),prods,rep('"},
                                      ',6), collapse=''),'
                                      Number : {$sum : 1}
    }}'), collapse=''))
    
    output <- dbAggregate(mongo, "arr", aggr_query)
    json <- lapply(output,jsonlite::fromJSON)
    datam <- do.call(rbind, json)
	if (is.null(datam)){
		datam = matrix(0,5,20)
		coln <- c('_id','CP','CLTV','depBal','Checking','MM','Mortgage','Home_eq','CC','StLoan','loanBal','Xsell','Age','CreditScore','InvestableAssetIndicator', 'CLTV1Y', 'CLTV3Y', 'CLTV5Y', 'CLTV10Y', 'Number')
		colnames(datam) <- coln
		datam[,'_id'] <- c(1,2,3,4,5)
    }
	coln <- colnames(datam)
    colnames(datam) <- c("Segment", coln[2:length(coln)])
    return(datam)
  })
  
  ## scatterplot
  output$transactional_scatterplot <- renderPlot({
	palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
		  "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
	p<-plot(scatterplot_data$method_webbank, scatterplot_data$method_mobile, col=scatterplot_data$segments, ylab='Y Component', xlab='X Component', main='Segmentation based on transactions')
	
	palette('default')
	return(p)
  })

  output$behavioural_scatterplot <- renderPlot({
	palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
		  "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
	p<-plot(scatterplot_data$dest_tech, scatterplot_data$dest_online, col=scatterplot_data$segments+4, ylab='Y Component', xlab='X Component', main='Segmentation based on behaviour')
	
	palette('default')
	return(p)
  })
	
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

	output$loyalp1 <- renderPlot({p<-qplot(x=problems_l,
									   y=problems_sc$loyal1,
									   geom='bar',
									   stat='identity',
									   ylab=c(),xlab=c())
								  p+theme(legend.position="none")},
								 height = 170)
	
	output$loyalp2 <- renderPlot({p<-qplot(x=problems_l,
									   y=problems_sc$loyal2,
									   geom='bar',
									   stat='identity',
									   ylab=c(),xlab=c())
								  p+theme(legend.position="none")},
								 height = 170)
								 
	output$loyalp3 <- renderPlot({p<-qplot(x=problems_l,
									   y=problems_sc$loyal3,
									   geom='bar',
									   stat='identity',
									   ylab=c(),xlab=c())
								  p+theme(legend.position="none")},
								 height = 170)
								 
	output$loyalp4 <- renderPlot({p<-qplot(x=problems_l,
									   y=problems_sc$loyal4,
									   geom='bar',
									   stat='identity',
									   ylab=c(),xlab=c())
								  p+theme(legend.position="none")},
								 height = 170)
	
	#fbmessages_loyalty
	#  CapCash
	#  CapFreedom
	#  CapRewards
	#  CapTravel
	  
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
	
## MAP COLORS    -------- TODO
  output$mapplot <- reactive({
#     input$selstates
  })  #when data changes, update the bar plot
  
  
  
## 360 Customer view
#observe({
#  input$updateBtn
#  
#})
  
  observe({
    c_id <- input$csd_custId
    clean_tables(output, session)
  })
  observe({
    input$updateBtn
    c_id <- isolate(input$csd_custId)
    if(c_id == 111111){
      output$t_customer_name <- renderText('Tony')
      output$t_customer_segment <- renderText('Mass Affluent')
      output$t_IAE <- renderText('$ 350,000')
      output$t_csc <- renderText('760')
      output$t_addr <- renderText('Customer #1 address')
      output$t_email <- renderText('Customer #1 email')
      output$t_ph <- renderText('Customer #1 Telephone')
      output$t_mar <- renderText('Married')
      output$t_nch <- renderText('2')
      output$t_zill <- renderText('$ 330,000')
      output$t_ehe <- renderText('$ 150,000')
	  output$t_soc_net_acc <- renderText('Yes')
	  output$t_home_improvement <- renderText('During last month')
      output$t_check_o <- renderText('Yes')
      output$t_check_b <- renderText('$ 3,500')
      output$t_mma_o <- renderText('No')
      output$t_mma_b <- renderText(' ')
      output$t_cc_o <- renderText('Yes')
      output$t_cc_b <- renderText('$ 2,000')
      output$t_mort_o <- renderText('Yes')
      output$t_mort_b <- renderText('$ 180,000')
      output$t_heloc_o <- renderText('No')
      output$t_heloc_b <- renderText(' ')
      output$t_stl_o <- renderText('No')
      output$t_stl_b <- renderText(' ')
      output$t_cp <- renderText('$ 700')
      output$t_cltv <- renderText('$ 6,000')
      output$t_nbo_sale <- renderText('MMA')
      output$t_nbo_prof <- renderText('MMA')
      
      output$myImage <- renderImage({
        list(src = 'www/raw/tony.png',
         contentType = 'image/png',
         width = 300,
         height = 300,
         alt = "This is alternate text")
      }, deleteFile = FALSE)
      
	  python.load("get_data.py")
	  python.load("get_customer_messages.py")
	  conversation_history <- python.call("get_user_messages", as.integer(111111))
#	  conversation_history <- lapply(conversation_history, as.list)
#     conversation_history <- rbindlist(conversation_history)
	  
    }else if(c_id == 222222){
      output$t_customer_name <- renderText('Customer #222222')
      output$t_customer_segment <- renderText('High Net Worth')
      output$t_IAE <- renderText('$ 700,000')
      output$t_csc <- renderText('810')
      output$t_addr <- renderText('Customer #222222 address')
      output$t_email <- renderText('Customer #222222 email')
      output$t_ph <- renderText('Customer #222222 Telephone')
      output$t_mar <- renderText('Married')
      output$t_nch <- renderText('3')
      output$t_zill <- renderText('$ 1,200,000')
      output$t_ehe <- renderText('$ 560,000')
	  output$t_soc_net_acc <- renderText('Yes')
	  output$t_home_improvement <- renderText('No')
      output$t_check_o <- renderText('Yes')
      output$t_check_b <- renderText('$ 16,000')
      output$t_mma_o <- renderText('Yes')
      output$t_mma_b <- renderText('$ 47,000')
      output$t_cc_o <- renderText('No')
      output$t_cc_b <- renderText(' ')
      output$t_mort_o <- renderText('Yes')
      output$t_mort_b <- renderText('$ 640,000')
      output$t_heloc_o <- renderText('Yes')
      output$t_heloc_b <- renderText('$ 100,000')
      output$t_stl_o <- renderText('No')
      output$t_stl_b <- renderText(' ')
      output$t_cp <- renderText('$ 700')
      output$t_cltv <- renderText('$ 6,000')
      output$t_nbo_sale <- renderText('Credit Card')
      output$t_nbo_prof <- renderText('Credit Card')
      
      output$myImage <- renderImage({
        list(src = 'www/raw/madman.png',
         contentType = 'image/png',
         width = 300,
         height = 300,
         alt = "This is alternate text")
      }, deleteFile = FALSE)
      
#      conversation_history <- conversation_history_mad
	  conversation_history <- python.call("get_user_messages", as.integer(222222))
      print(conversation_history)
    }else if(c_id == 0){
      clean_tables(output, session)
      conversation_history <- c()
	  
    }else{
      output_db <- dbGetQuery(mongo, "arr", paste0('{"X_id":',as.character(c_id),'}', collapse=""))
      zillow <- 330000
      output$t_customer_name <- renderText(output_db$Name)
      output$t_customer_segment <- renderText(segs[output_db$Segment])
      output$t_IAE <- renderText(output_db$InvestableAssetIndicator)
      output$t_csc <- renderText(output_db$CreditScore)
      output$t_addr <- renderText(paste0('Customer #',c_id,' address', collapse=""))
      output$t_email <- renderText(paste0('Customer #',c_id,' email', collapse=""))
      output$t_ph <- renderText(paste0('Customer #',c_id,' phone #', collapse=""))
      output$t_mar <- renderText(ifelse(output_db$Mar == 'Mar', marstat[1], marstat[2]))
      output$t_nch <- renderText(output_db$ChNum)
      output$t_zill <- renderText(paste0('$ ', zillow, collapse=""))
      output$t_ehe <- renderText(paste0('$ ', ifelse(output_db$Mortgage, output_db$zillow-output_db$MortgageBalance, ' - ')))
  	  output$t_soc_net_acc <- renderText(ifelse(output_db$has_fb_acc, 'Yes', 'No'))
	  output$t_home_improvement <- renderText(ifelse(output_db$has_fb_acc, ifelse(output_db$looked_for_house==0,'No', ifelse(output_db$looked_for_house==1,'During last month', paste0(output_db$looked_for_house, ' months ago', collapse=""))), ' - '))
      output$t_check_o <- renderText(ifelse(output_db$Checking,'Yes', 'No'))
      output$t_check_b <- renderText(ifelse(output_db$Checking, paste0('$ ', output_db$CheckingBalance), 0))
      output$t_mma_o <- renderText(ifelse(output_db$MM,'Yes', 'No'))
      output$t_mma_b <- renderText(ifelse(output_db$MM, paste0('$ ', output_db$MMBalance), 0))
      output$t_cc_o <- renderText(ifelse(output_db$CC,'Yes', 'No'))
      output$t_cc_b <- renderText(ifelse(output_db$CC, paste0('$ ', output_db$CCBalance), 0))
      output$t_mort_o <- renderText(ifelse(output_db$Mortgage, 'Yes', 'No'))
      output$t_mort_b <- renderText(ifelse(output_db$Mortgage, paste0('$ ', output_db$MortgageBalance), 0))
      output$t_heloc_o <- renderText(ifelse(output_db$Home_eq, 'Yes', 'No'))
      output$t_heloc_b <- renderText(ifelse(output_db$Home_eq, paste0('$ ', output_db$Home_eqBalance), 0))
      output$t_stl_o <- renderText(ifelse(output_db$StLoan,'Yes', 'No'))
      output$t_stl_b <- renderText(ifelse(output_db$StLoan, paste0('$ ', output_db$StLoanBalance), 0))
      output$t_cp <- renderText(paste0('$ ', output_db$CP))
      output$t_cltv <- renderText(paste0('$ ', output_db$fp1y_prod))
      output$t_nbo_sale <- renderText(output_db$NBO)
      output$t_nbo_prof <- renderText(output_db$NBO)
    }

    len <- length(conversation_history)
    # if((nchar(isolate(input$newMessage))==0) && (len>0)){
      # nr <- nrow(conversation_history)
      # conversation_history <- conversation_history[2:nr,]
      # ch_class <- 0
    # }else{
      # ch_class <- 1
    # }

    tablo <- paste0('
      <style type="text/css">
        .tg  {border-collapse:collapse;  border-spacing:0;}
        .tg .tg-ly0g-1 {font-weight:bold;background-color:#ffffff;text-align:center}
        .tg .tg-j4kc-1{background-color:#efefef;text-align:center}
        .tg .tg-j4kc-2{background-color:#8CFA64;text-align:center}
        .tg .tg-j4kc-3{background-color:#ef6f6f;text-align:center}
      </style>
      <table class="tg" width=100%>
        <tr>
          <th class="tg-ly0g-1">Recent Conversation History</th>
          <th class="tg-ly0g-1">Conversation Summary</th>
          <th class="tg-ly0g-1">Bank Channel</th>
          <th class="tg-ly0g-1">Consumer Sentiment</th>
        </tr>')
	print('ok')
		
    if(len > 0){
      nr <- length(conversation_history)
      nc <- length(conversation_history_header)

      for(i in 1:nr){
        tablo <- paste0(tablo,'  <tr>
                              ', collapse="")
          
        for(j in 1:nc){
          if(conversation_history[[i]][['sent']]=="Very Angry"){
            tablo <- paste0(tablo,'  <td class="tg-j4kc-3">', collapse="")
#          }else if(ch_class && i==1){
#            tablo <- paste0(tablo,'  <td class="tg-j4kc-2">', collapse="")              
          }else if((j==3) && (conversation_history[[i]][['source']]=='facebook')){
            tablo <- paste0(tablo,'  <td class="tg-j4kc-2">', collapse="") 			
          }else{
            tablo <- paste0(tablo,'  <td class="tg-j4kc-1">', collapse="")              
          }
		  if(j==1){
			tablo <- paste0(tablo, substr(conversation_history[[i]][[conversation_history_header[j]]],1,10) , collapse="")
		  }else{
		    tablo <- paste0(tablo, conversation_history[[i]][[conversation_history_header[j]]] , collapse="")
		  }
          tablo <- paste0(tablo,'</td>
                              ', collapse="")
        }
        tablo <- paste0(tablo,'</tr>
                            ', collapse="")
      }
    }
	
    tablo <- paste0(tablo,'</table>', collapse="")
    print(tablo)
    
    html_p = data.frame(html=tablo)
    session$sendCustomMessage(type='HTML_paste',html_p)
  })
  
  observe({
    input$updateBtn
    change = 0
    if(isolate(input$csd_mar) != 'No changes'){
      change <- 1
    }
    if(isolate(input$csd_ch) != 'No changes'){
      change <- 1
    }
    if(isolate(input$csd_job) != 'No changes'){
      change <- 1
    }
    if(isolate(input$csd_bh) != 'No changes'){
      change <- 1
    }
    if(isolate(input$csd_ch_age) != 'No changes'){
      change <- 1
    }
    if(isolate(input$csd_ch_age2) != 'No changes'){
      change <- 1
    }
    if(isolate(input$csd_ret) != 'No changes'){
      change <- 1
    }
    if(isolate(input$home_empr) != 'No'){
      change <- 1
    }
    
    if(change & (isolate(input$csd_custId) == 111111)){
      output$t_nbo_rev <- renderText('HELOC')
      output$t_cltv_rev <- renderText('$ 6,000')
    }else if(isolate(input$csd_custId) == 222222){
      output$t_nbo_rev <- renderText('- DNC -')
      output$t_cltv_rev <- renderText('$ 50')
    }else{
      output$t_nbo_rev <- renderText('-')
      output$t_cltv_rev <- renderText('-')
    }
  })
  
  
## PRINT STATES
  output$results <- renderPrint({
    st$name[st$id %in% input$selstates]
  })
  
#  group_r <- reactive({ return(sement_v) })
  
## PLOT CLTV/CP BARCHART
  observe({
    datam <- datam_r()
    missed_v <- !(segment_v %in% datam[,'Segment'])
    mmCP <- cbind(Segment = paste0('# ', datam[,'Segment']), 
                  Value = datam[,'CP'], Type='CP', Number = datam[,'Number'])
    
    if(any(missed_v)){
      mmCP_miss <- cbind(Segment = paste0('# ', segment_v[missed_v]), 
                    Value = 0, Type='CP', Number = 0)
      mmCP <- rbind(mmCP, mmCP_miss)
    }
    session$sendCustomMessage(type='CLTVhandler',mmCP)
    
# 		y <- c(sum(unlist(datam[,'CLTV1Y'])),
# 					sum(unlist(datam[,'CLTV3Y'])),
# 					sum(unlist(datam[,'CLTV5Y'])),
# 					sum(unlist(datam[,'CLTV10Y'])))
		# Discount rate same as on data generation stage
# 		ri <- 0.01
# 		x <- c(1,3,5,10)
# 		x2 <- 1:10
# 		y2 <- approx(x,y,x2)
# 		y2$y <- y2$y/(1+ri)^y2$x
# 		
# 		mmCLTV <- cbind(Year = y2$x, 
# 										CLTVs = y2$y,
# 										CLTV='Predicted')
#     
#     session$sendCustomMessage(type='CLTVhandler_2',rbind(mmCLTV,mmCLTV2))
    
  })
  
  observe({
    if(input$getMess[1] > 0){
      mess_id <- ((input$getMess[1]-1) %% 7) + 1
      mess <- message_data[mess_id, ]
      cust_number <- mess$cust_number
      mess$name <- paste0('Customer #',as.character(cust_number), collapse="")
      
      session$sendCustomMessage(type = "mess_cb", mess)
    }
  })
  

  observe({
#     aggr_query <- c()
#     sts <- st$name[st$id %in% isolate(input$selstates)]
#     all_states <- 0
# 
#     if (length(sts) == 0){
#       sts <- st$name
#       all_states <- 1
#     }else{
#       filter_str <- paste0(c(' { "$match" : {$or: [ ', paste0('{ State: "', sts, '" }', collapse=","),'] }}'), collapse="")
#       aggr_query <- c(aggr_query, filter_str)
#     }
    input$updateBtnccl[1]

    aggr_query <- isolate(aggr_query_flt())
    aggr_query <- c(aggr_query, '{ $limit: 100 }')
        
    output_db_ccl <- dbAggregate(mongo, "arr", aggr_query)
    json <- lapply(output_db_ccl,jsonlite::fromJSON)
    datam <- do.call(rbind, json)
    datam2 <- datam[,c('X_id', 'Name', 'Segment', 'State', 'NBO', 'PreferredContactChannel')]
    colnames(datam2) = c('Customer Number',  'Customer Name',	'Customer Segment',	'State of Residence','Product Offering','Preferred Channel for Contact')
    output$camp_client_list <- renderDataTable(datam2, options = list(pageLength = 10, searching = FALSE))
  })
  
  observe({
    tablo <- paste0('
      <style type="text/css">
        .tg  {border-collapse:collapse;border-spacing:0; width:100%}
        .tg td{font-family:Arial, sans-serif;font-size:14px;padding:5px 20px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;}
        .tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:5px 20px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;}
        .tg .tg-pmlc{font-weight:bold;background-color:#bcbdf0;color:#656565;text-align:center}
        .tg .tg-8bj5{background-color:#cbcefb;color:#656565;text-align:center}
        .tg .tg-0y5s{font-weight:bold;background-color:#cbcefb;color:#656565;text-align:center}
        .tg .tg-pug3{background-color:#bbdaff;color:#656565}
        .tg .tg-pug32{background-color:#cbeaff;color:#656565}
        .tg .tg-imam{background-color:#ddfaff;color:#656565;text-align:center}
        .tg .tg-imam2{background-color:#cceaff;color:#656565;text-align:center}
      </style>
      <table class="tg">
        <tr>
          <th class="tg-8bj5">Segment</th>
          <th class="tg-8bj5">Customer Information</th>
          <th class="tg-8bj5" colspan="5">Product Information</th>
          <th class="tg-0y5s" colspan="2">Customer Value</th>
        </tr>
        <tr>
            <td class="tg-pmlc"></td>
            <td class="tg-pmlc"># Customers</td>
            <td class="tg-pmlc" colspan="2">Deposit Product Information</td>
            <td class="tg-pmlc" colspan="2">Loan Product Information</td>
            <td class="tg-pmlc"></td>
            <td class="tg-pmlc">Anual CP</td>
            <td class="tg-pmlc">CLTV</td>
          </tr>
          ')
    
    datam <- data.frame(datam_r())
    datam <- sapply(datam, unlist)
    datam <- data.frame(datam)
    
    ## Segment  grouping
    datam <- datam[order(datam$Segment),]
    group.crname <- c('Segment 1: Mass Market', 'Segment 2: Young Professional', 'Segment 3: Mass Afluent', 'Segment 4: Affluent', 'Segment 5: High Net Worth')

    group.n <- length(group.crname)
    group.tval.ncust <- datam$Number
    group.tval.dtbal <- datam$depBal*datam$Number
    group.tval.dnum <- (datam$Checking + datam$MM)*datam$Number
    group.tval.ltbal <- datam$loanBal*datam$Number
    group.tval.lnum <- (datam$Home_eq + datam$CC + datam$StLoan + datam$Mortgage)*datam$Number
    group.tval.nprod <- datam$Xsell*datam$Number
    group.tval.cp <- datam$CP*datam$Number
    group.tval.cltv <- datam$CLTV*datam$Number
    
    group.avg.dtbal <- datam$depBal
    group.avg.dnum <- (datam$Checking + datam$MM)
    group.avg.ltbal <- datam$loanBal
    group.avg.lnum <- (datam$Home_eq + datam$CC + datam$StLoan + datam$Mortgage)
    group.avg.nprod <- datam$Xsell
    group.avg.cp <- datam$CP
    group.avg.cltv <- datam$CLTV

    for (gri in 1:group.n){
      if (gri == 1){
        tablo <- paste0(tablo, '<tr>
              <td class="tg-pug3">', group.crname[1] , '</td>
              <td class="tg-imam"></td>
              <td class="tg-imam">Total Balances</td>
              <td class="tg-imam"># of Deposit Products</td>
              <td class="tg-imam">Total Outstanding</td>
              <td class="tg-imam"># of Loan Products</td>
              <td class="tg-imam">Total # of Products</td>
              <td class="tg-imam">Total</td>
              <td class="tg-imam">Total</td>
            </tr>
            ', collapse = "")
      } else {
        tablo <- paste0(tablo, '<tr>
              <td class="tg-pug3">', group.crname[gri] , '</td>
              <td class="tg-imam2" colspan="8"></td>
            </tr>
            ', collapse = "")
      }
      tablo <- paste0(tablo, '<tr>
            <td class="tg-pug32">Total</td>
            <td class="tg-imam">', sprintf('%.0f', group.tval.ncust[gri]),'</td>
            <td class="tg-imam">', format(round(group.tval.dtbal[gri]), big.mark=","),' USD','</td>
            <td class="tg-imam">', sprintf('%.0f', group.tval.dnum[gri]),'</td>
            <td class="tg-imam">', format(round(group.tval.ltbal[gri]), big.mark=","),' USD','</td>
            <td class="tg-imam">', sprintf('%.0f', group.tval.lnum[gri]),'</td>
            <td class="tg-imam">', sprintf('%.0f', group.tval.nprod[gri]),'</td>
            <td class="tg-imam">', format(round(group.tval.cp[gri]), big.mark=","),' USD','</td>
            <td class="tg-imam">', format(round(group.tval.cltv[gri]), big.mark=","),' USD','</td>
          </tr>
          <tr>
            <td class="tg-pug32">Per Customer</td>
            <td class="tg-imam"></td>
            <td class="tg-imam">', format(round(group.avg.dtbal[gri]), big.mark=","),' USD','</td>
            <td class="tg-imam">', sprintf('%.2f',group.avg.dnum[gri]),'</td>
            <td class="tg-imam">', format(round(group.avg.ltbal[gri]), big.mark=","),' USD','</td>
            <td class="tg-imam">', sprintf('%.2f',group.avg.lnum[gri]),'</td>
            <td class="tg-imam">', sprintf('%.2f',group.avg.nprod[gri]),'</td>
            <td class="tg-imam">', format(round(group.avg.cp[gri]), big.mark=","),' USD','</td>
            <td class="tg-imam">', format(round(group.avg.cltv[gri]), big.mark=","),' USD','</td>
          </tr>
      ', collapse = "")
    }
    tablo <- paste0(tablo, '</table>', collapse = "")
    
#     if(len > 0){
#       nr <- nrow(conversation_history)
#       nc <- ncol(conversation_history)
# 
#       for(i in 1:nr){
#         tablo <- paste0(tablo,'  <tr>
#                               ', collapse="")
#           
#         for(j in 1:nc){
#           if(conversation_history[i,nc]=="Very Angry"){
#             tablo <- paste0(tablo,'  <td class="tg-j4kc-3">', collapse="")
#           }else if(ch_class && i==1){
#             tablo <- paste0(tablo,'  <td class="tg-j4kc-2">', collapse="")              
#           }else{
#             tablo <- paste0(tablo,'  <td class="tg-j4kc-1">', collapse="")              
#           }
#           tablo <- paste0(tablo, conversation_history[i, j] , collapse="")
#           tablo <- paste0(tablo,'</td>
#                               ', collapse="")
#         }
#         tablo <- paste0(tablo,'</tr>
#                             ', collapse="")
#       }
#     }
    
#    tablo <- paste0(tablo,'</table>', collapse="")
    
    html_p = data.frame(html=tablo)
    session$sendCustomMessage(type='HTML_paste2',html_p)


  })
  
  # observe({
    # input$updateBtn_social
# #    python.load('get_data.py')
# #    messages <- python.get("messages")
    
# #    len = length(messages)
    
    # table_message <- paste0('
    # <style type="text/css">
		# .tg  {border-collapse:collapse;  border-spacing:0;}
		# .tg .tg-ly0g-1 {font-weight:bold;background-color:#ffffff;text-align:center}
		# .tg .tg-j4kc-1{background-color:#efefef;text-align:center}
		# .tg .tg-j4kc-2{background-color:#cfefcf;text-align:center}
		# .tg .tg-j4kc-3{background-color:#ef6f6f;text-align:center}
		# </style>
	# <table class="tg" width=100%>
		# <tr>
			# <th class="tg-ly0g-1">Message</th>
			# <th class="tg-ly0g-1">Sourse</th>
			# <th class="tg-ly0g-1">Profile Name</th>
			# <th class="tg-ly0g-1">Date</th>
			# <th class="tg-ly0g-1">Time</th>
			# <th class="tg-ly0g-1">Sentiment</th>
		# </tr>
        # ')
    # if(len > 0){
      # nr <- len
      # nc <- 6
      # hocell <- '<td>'
      # eocell <- '</td>
                      # '
      # for(i in 1:nr){
		# sent = messages[[i]][['sentiment']][['type']]
		# if (sent == 'positive'){
			# table_message <- paste0(table_message,'<tr class="tg-j4kc-2">
                      # ', collapse="")
		# } else if (sent == 'neutral') {
			# table_message <- paste0(table_message,'<tr class="tg-j4kc-1">
                      # ', collapse="")
		# } else {
			# table_message <- paste0(table_message,'<tr class="tg-j4kc-3">
                      # ', collapse="")
		# }
  
# #        table_message <- paste0(table_message,'<  td">', collapse="")
# #           if(conversation_history[i,nc]=="Very Angry"){
# #             table_message <- paste0(table_message,'  <td class="tg-j4kc-3">', collapse="")
# #           }else if(ch_class && i==1){
# #             table_message <- paste0(table_message,'  <td class="tg-j4kc-2">', collapse="")
# #           }else{
# #             table_message <- paste0(tablo,'  <td class="tg-j4kc-1">', collapse="")
# #           }
        # table_message <- paste0(table_message, hocell, messages[[i]][['message']] , eocell, collapse="")
        # table_message <- paste0(table_message, hocell, 'facebook' , eocell, collapse="")
        # table_message <- paste0(table_message, hocell, messages[[i]][['from']] , eocell, collapse="")
        # date_long <- strsplit(messages[[i]][['date']], split="[T+]")
        # table_message <- paste0(table_message, hocell, date_long[[1]][[1]] , eocell, collapse="")
        # table_message <- paste0(table_message, hocell, date_long[[1]][[2]] , eocell, collapse="")
        # table_message <- paste0(table_message, hocell, sent, eocell, collapse="")
        # table_message <- paste0(table_message,'</tr>
                    # ', collapse="")
      # }
    # }
    # table_message <- paste0(table_message,'</table>', collapse="")
    # html = data.frame(html=table_message)
    # session$sendCustomMessage(type='HTML_paste_social',html)
  # })

  ##############################################################################
#     ###Midwest#################################### 
#   output$plots <- renderUI({
#     data<- read.csv("/home/biadmin/projects/shiny_app/IAP/LiveChat100Examples.csv")
#     a<- table(data$Region,data$Consumer.Sentiment)
#     a<-as.data.frame(a)
#     am<-a[which(a$Var1=="Midwest"),]
#     
#     Angry=am[1,3]
#     Disappointed=am[2,3]
#     Happy=am[3,3]
#     Neutral=am[4,3]
#     VA = am[5,3]
#     Total=c(Angry,Disappointed,Happy,Neutral,VA)
#     someDF <<- structure(list(Variable.Type = c("Angry", "Disappointed", "Happy","Neutral","Very Angry"), 
#                               Total=c(Angry,Disappointed,Happy,Neutral,VA)), .Names = c("Variable.Type",                                                                               
#                                                                                         "Total"), row.names = c(NA, -3L), class = "data.frame")
#     
#     #  list = unique(someDF$Market)
#     plot_output_list <- lapply(1, function(i) {
#       plotname <- paste("plot", i, sep="")
#       chartOutput(plotname, "highcharts")
#     })
#     
#     do.call(tagList, plot_output_list)
#   })
#   
#   i=1  
#   local({
#     my_i <- i
#     plotname <- paste("plot", my_i, sep="")
#     
#     output[[plotname]] <- renderChart2({
#       print(my_i)
#       plotData = subset(someDF)
#       #print(plotData)
#       p<-hPlot(Total ~ Variable.Type, data = plotData, type='pie')
#       p$colors('rgba(210, 77, 87,50)', 'rgba( 249, 105, 14,50)', 'rgba(135, 211, 124, 50)' ,'rgba(247, 202, 24, 50)','rgba(207, 0, 15, 50)')
#      # p$plotOptions(pie = list(size = "70%",innerSize = "80%", startAngle = -90, endAngle = 90, center = list("50%", "75%")))
#      p$addParams(height = 300, width = 400)
#      p
#     })
#   })
#   ###south####################################
#   output$plots1 <- renderUI({
#     data<- read.csv("/home/biadmin/projects/shiny_app/IAP/LiveChat100Examples.csv")
#     a<- table(data$Region,data$Consumer.Sentiment)
#     a<-as.data.frame(a)
# 
#     as<-a[which(a$Var1=="South"),]
#     as1<-as
# 
#     Angry=as1[1,3]
#     Disappointed=as1[2,3]
#     Happy=as1[3,3]
#     Neutral=as1[4,3]
#     VA = as1[5,3]
#     Total=c(Angry,Disappointed,Happy,Neutral,VA)
#     someDF1 <<- structure(list(Variable.Type = c("Angry", "Disappointed", "Happy","Neutral","Very Angry"), 
#                                Total=c(Angry,Disappointed,Happy,Neutral,VA)), .Names = c("Variable.Type",                                                                               
#                                                                                          "Total"), row.names = c(NA, -3L), class = "data.frame")
#     
#     #  list = unique(someDF$Market)
#     plot_output_list1 <- lapply(1, function(j) {
#       plotname1 <- paste("plot1", j, sep="")
#       chartOutput(plotname1, "highcharts")
#     })
#     
#     do.call(tagList, plot_output_list1)
#   })
#   
#   j=1  
#   local({
#     my_j <- j
#     plotname1 <- paste("plot1", my_j, sep="")
#     
#     output[[plotname1]] <- renderChart2({
#       print(my_j)
#       plotData1 = subset(someDF1)
#       #print(plotData)
#       p<-hPlot(Total ~ Variable.Type, data = plotData1, type='pie',col=12:20)
#       p$colors('rgba(210, 77, 87,50)', 'rgba( 249, 105, 14,50)', 'rgba(135, 211, 124, 50)' ,'rgba(247, 202, 24, 50)','rgba(207, 0, 15, 50)')
#       #p$plotOptions(pie = list(size = "70%",innerSize = "80%", startAngle = -90, endAngle = 90, center = list("50%", "75%")))
#       p$addParams(height = 300, width = 400)
#       p
#     })
#   })
#   
#   
#   
#   ###Northeast####################################
#   output$plots2 <- renderUI({
#     Angry=an[1,3]
#     Disappointed=an[2,3]
#     Happy=an[3,3]
#     Neutral=an[4,3]
#     VA = an[5,3]
#     Total=c(Angry,Disappointed,Happy,Neutral,VA)
#     someDF2 <<- structure(list(Variable.Type = c("Angry", "Disappointed", "Happy","Neutral","Very Angry"), 
#                                Total=c(Angry,Disappointed,Happy,Neutral,VA)), .Names = c("Variable.Type",                                                                               
#                                                                                          "Total"), row.names = c(NA, -3L), class = "data.frame")
#     
#     #  list = unique(someDF$Market)
#     plot_output_list2 <- lapply(1, function(j) {
#       plotname2 <- paste("plot2", j, sep="")
#       chartOutput(plotname2, "highcharts")
#     })
#     
#     do.call(tagList, plot_output_list2)
#   })
#   
#   k=1  
#   local({
#     my_k <- k
#     plotname2 <- paste("plot2", my_k, sep="")
#     
#     output[[plotname2]] <- renderChart2({
#       print(my_k)
#       plotData2 = subset(someDF2)
#       #print(plotData)
#       p<-hPlot(Total ~ Variable.Type, data = plotData2, type='pie',col=12:20)
#       p$colors('rgba(210, 77, 87,50)', 'rgba( 249, 105, 14,50)', 'rgba(135, 211, 124, 50)' ,'rgba(247, 202, 24, 50)','rgba(207, 0, 15, 50)')
# #         p$plotOptions(pie = list( startAngle = -90, endAngle = 90, center = list("50%", "75%")))
#       p$addParams(height = 300, width = 400)
#       p
#     })
#   })
#   
#   
#   ###West####################################
#   output$plots3 <- renderUI({
#     Angry=aw[1,3]
#     Disappointed=aw[2,3]
#     Happy=aw[3,3]
#     Neutral=aw[4,3]
#     VA = aw[5,3]
#     Total=c(Angry,Disappointed,Happy,Neutral,VA)
#     someDF3 <<- structure(list(Variable.Type = c("Angry", "Disappointed", "Happy","Neutral","Very Angry"), 
#                                Total=c(Angry,Disappointed,Happy,Neutral,VA)), .Names = c("Variable.Type",                                                                               
#                                                                                          "Total"), row.names = c(NA, -3L), class = "data.frame")
#     
#     #  list = unique(someDF$Market)
#     plot_output_list3 <- lapply(1, function(j) {
#       plotname3 <- paste("plot3", j, sep="")
#       chartOutput(plotname3, "highcharts")
#     })
#     
#     do.call(tagList, plot_output_list3)
#   })
#   
#   l=1  
#   local({
#     my_l <- l
#     plotname3 <- paste("plot3", my_l, sep="")
#     
#     output[[plotname3]] <- renderChart2({
#       print(my_l)
#       plotData3 = subset(someDF3)
#       #print(plotData)
#       p<-hPlot(Total ~ Variable.Type, data = plotData3, type='pie',col=12:20)
#       p$colors('rgba(210, 77, 87,50)', 'rgba( 249, 105, 14,50)', 'rgba(135, 211, 124, 50)' ,'rgba(247, 202, 24, 50)','rgba(207, 0, 15, 50)')
#       #p$plotOptions(pie = list(size = "70%",innerSize = "80%", startAngle = -90, endAngle = 90, center = list("50%", "75%")))
#       p$addParams(height = 300, width = 400)
#       p
#     })
#   })
#   
#   ###new plot####################################
#   output$plots4 <- renderUI({
#   
#     plot_output_list4 <- lapply(1, function(j) {
#       plotname4 <- paste("plot4", j, sep="")
#       chartOutput(plotname4, "highcharts")
#     })
#     
#     do.call(tagList, plot_output_list4)
#   })
#   
#   g=1  
#   local({
#     my_g <- g
#     plotname4 <- paste("plot4", my_g, sep="")
#     
#     output[[plotname4]] <- renderChart2({
#       print(my_g)
#       data<- read.csv("/home/biadmin/projects/shiny_app/IAP/LiveChat100Examples.csv")
#       s<-as.data.frame(table(data$Category))
#       y1<-s[1,2]
#       y2<-s[2,2]
#       y3<-s[3,2]
#       y4<-s[4,2]
#       p <- hPlot(Count ~ x, data = data.frame(x = c("Code Red Complaint","Complaint","Complement","Question"), Count = c(y1,y2,y3,y4)), type = "column")
#       
#       p$xAxis(title = list(text = "Category"), categories = list("Code Red Complaint","Complaint","Complement","Question"))
#       p$show("inline", include_assets = FALSE)
#       p$addParams(height = 400, width = 600)
#   
#       p
#     })
#   })
#   
#   output$wordcloud <-renderPlot({
#     
#     
#     lords <- Corpus(VectorSource(data$Text.Content))
#     inspect(lords)
#     lords <- tm_map(lords, stripWhitespace)
#     lords <- tm_map(lords, content_transformer(tolower))
#     lords <- tm_map(lords, removeWords, stopwords("english"))
#     lords <- tm_map(lords, stemDocument)
#     lords
#     wordcloud(lords, scale=c(5,0.5), max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
#     
#   })
  ##############################################################################
})

# output <- dbAggregate(mongo, "test_data", c(' { "$project" : { "baz" : "$foo" } } ',
# ' { "$group" : { "_id" : "$baz" } } ',
# ' { "$match" : { "_id" : "bar" } } '))


#       output$table_mess <- renderUI({
#         nr <- nrow(conversation_history)
#         nc <- ncol(conversation_history)
#         tablo <- '<style type="text/css"> .tg  {border-collapse:collapse;border-spacing:0;}.tg .tg-ly0g-1{font-weight:bold;background-color:#ffffff;text-align:center}.tg .tg-j4kc-1{background-color:#efefef;text-align:center}</style><table class="tg" width=100%><tr><th class="tg-ly0g-1">Recent Conversation History</th><th class="tg-ly0g-1">Conversation Summary</th><th class="tg-ly0g-1">Bank Channel</th><th class="tg-ly0g-1">Categorization</th><th class="tg-ly0g-1">Consumer Sentiment</th></tr>'
#         for(i in 1:nr){
#           tablo <- paste0(tablo,'<tr>', collapse="")
#             
#           for(j in 1:nc){
#             tablo <- paste0(tablo,'</td class="tg-j4kc-1>', collapse="")
#             
#             tablo <- paste0(tablo, conversation_history[i, j] , collapse="")
#             
#             tablo <- paste0(tablo,'</td>', collapse="")
#           }
#           tablo <- paste0(tablo,'</tr>', collapse="")
#         }
#         tablo <- paste0(tablo,'</table>', collapse="")
#         return(HTML(tablo))
#       })
    
#   observe({
#     input$updateBtnccl[1]
# 
#     tablo <- paste0('
#       <style type="text/css">
#         .tg  {border-collapse:collapse;  border-spacing:0;}
#         .tg .tg-ly0g-1 {font-weight:bold;background-color:#ffffff;text-align:center}
#         .tg .tg-j4kc-1{background-color:#efefef;text-align:center}
#       </style>
#       <table class="tg" width=100%>
#         <tr>
#           <th class="tg-ly0g-1">Recent Conversation History</th>
#           <th class="tg-ly0g-1">Conversation Summary</th>
#           <th class="tg-ly0g-1">Bank Channel</th>
#           <th class="tg-ly0g-1">Categorization</th>
#           <th class="tg-ly0g-1">Consumer Sentiment</th>
#         </tr>')
#     nr <- nrow(conversation_history)
#     nc <- ncol(conversation_history)
#     for(i in 1:nr){
#       tablo <- paste0(tablo,'  <tr>
#                             ', collapse="")
#         
#       for(j in 1:nc){
#         tablo <- paste0(tablo,'  <td class="tg-j4kc-1">', collapse="")              
#         tablo <- paste0(tablo, conversation_history[i, j] , collapse="")
#         tablo <- paste0(tablo,'</td>
#                             ', collapse="")
#       }
#       tablo <- paste0(tablo,'</tr>
#                           ', collapse="")
#     }          
#     tablo <- paste0(tablo,'</table>', collapse="")
#     noquote(tablo)
#     
#     
#     html_p = data.frame(html=tablo)
#     session$sendCustomMessage(type='HTML_paste',html_p)
#   })
  
#   output$barplot <- reactive({
#     input$selstates
#   })  #when data changes, update the bar plot

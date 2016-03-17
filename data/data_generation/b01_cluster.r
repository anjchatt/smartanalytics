
capdf <- rep(0,100)
capdf[18:60] <- c(1, 2, (0:40)/(-40)*2+3)
capdf <- capdf/sum(capdf)
p_iter_ca <- iterative_prob(capdf)

edu_pdf <- f_edu()
p_iter_edu <- iterative_prob(edu_pdf)

mar_pdf <- f_mar()
p_iter_mar <- iterative_prob(mar_pdf)

chk_pdf <- f_checking_prob()
p_iter_chk <- iterative_prob(chk_pdf)

mm_pdf <- f_mm_prob()
p_iter_mm <- iterative_prob(mm_pdf)

mortgage_pdf <- f_mortgage_prob()
p_iter_mortgage <- iterative_prob(mortgage_pdf)

home_eq_pdf <- f_home_eq_prob()
p_iter_home_eq <- iterative_prob(home_eq_pdf)

stloan_pdf <- f_stloan_prob()
p_iter_stloan <- iterative_prob(stloan_pdf)

cc_pdf <- f_cc_prob()
p_iter_cc <- iterative_prob(cc_pdf)

stop_prob_pdf <- f_stop_prob()
p_iter_stop <- iterative_prob(stop_prob_pdf)

n2 <- 80-18+1
edu_age <- rep(1,n)

customer <- alist()
customers <- data.frame(Id=rep(0,n2),
                        Age=rep(0,n2),
                        Edu=rep(F,n2),
                        Mar=rep(F,n2),
                        Inc=rep(0,n2),
                        SocialStat=rep(factor("Student", levels=c('Student','Employed','Military','Self-Employed','Retired')),n2),
                        REStat=rep(factor("Lives_with_relatives", levels=c('Owner','Social_rent','Rent','Lives_with_relatives')),n2),
                        ChNum=rep(0,n2),
                        ChAge=rep(0,n2),
                        WorkExp=rep(0,n2),
                        Traveled=rep(F,n2),
                        
                        Checking=rep(F,n2),
                        MM=rep(F,n2),
                        Mortgage=rep(F,n2),
                        Home_eq=rep(F,n2),
                        CC=rep(F,n2),
                        StLoan=rep(F,n2),

                        ypChecking=rep(0,n2),
                        ypMM=rep(0,n2),
                        ypMortgage=rep(0,n2),
                        ypHome_eq=rep(0,n2),
                        ypCC=rep(0,n2),
                        ypStLoan=rep(0,n2),
                        
                        pChecking=rep(0,n2),
                        pMM=rep(0,n2),
                        pMortgage=rep(0,n2),
                        pHome_eq=rep(0,n2),
                        pCC=rep(0,n2),
                        pStLoan=rep(0,n2),
                        
                        fpChecking=rep(0,n2),
                        fpMM=rep(0,n2),
                        fpMortgage=rep(0,n2),
                        fpHome_eq=rep(0,n2),
                        fpCC=rep(0,n2),
                        fpStLoan=rep(0,n2),
                        
                        nChecking=rep(F,n2),
                        nMM=rep(F,n2),
                        nMortgage=rep(F,n2),
                        nHome_eq=rep(F,n2),
                        nCC=rep(F,n2),
                        nStLoan=rep(F,n2),
                        
                        mail_offer=rep(F,n2),
                        phone_offer=rep(F,n2),
                        email_offer=rep(F,n2),
                        
                        mail_resp=rep(F,n2),
                        phone_resp=rep(F,n2),
                        email_resp=rep(F,n2),
                        
                        mail_acq=rep(F,n2),
                        phone_acq=rep(F,n2),
                        email_acq= rep(F,n2),
                        
                        stringsAsFactors=TRUE)

customers_clean <- customers

products <- c("Checking","MM","Mortgage","Home_eq","CC","StLoan")
products_yp <- paste0(rep("yp", length(products)), products)
products_p <- paste0(rep("p", length(products)), products)
products_n <- paste0(rep("n", length(products)), products)
products_fp <- paste0(rep("fp", length(products)), products)

comm_ch <- c("mail", "phone", "email")
comm_inf <- c(
    paste0(comm_ch, rep("_offer", 3)),
    paste0(comm_ch, rep("_resp", 3)),
    paste0(comm_ch, rep("_acq", 3)))

logical_id <- c(products, products_n, comm_inf, "Traveled", "Mar", "Edu")

types <- rep("", length(customers))
for(i in 1:length(types)){
  types[i] <- typeof(customers[1,i])
}

for(i in 1:n){
  customers <- customers_clean
  
  Edu_ <- F
  Mar_ <- F
  Inc_ <- f_income_init(1)
  ChNum_ <- 0
  ChAge_ <- 0
  WorkExp_ <- 0
  REStat_ <- 'Lives_with_relatives'
  
  Checking_ <- F
  MM_ <- F
  Mortgage_ <- F
  Home_eq_ <- F
  
  customer$Id <- i
  customer$pMM <- 0
  customer$pMortgage <- 0
  customer$pHome_eq <- 0
  
  customer$Checking <- F
  customer$MM <- F
  customer$Mortgage <- F
  customer$Home_eq <- F
  customer$CC <- F
  customer$StLoan <- F
  
  customer$ypChecking <- 0
  customer$ypMM <- 0
  customer$ypMortgage <- 0
  customer$ypHome_eq <- 0
  customer$ypCC <- 0
  customer$ypStLoan <- 0
  
  customer$mail_offer<-F
  customer$phone_offer<-F
  customer$email_offer<-F
  
  customer$mail_resp<-F
  customer$phone_resp<-F
  customer$email_resp<-F
  
  customer$mail_acq<-F
  customer$phone_acq<-F
  customer$email_acq<-F

  guy_trend <- (1+runif(1)*2)
	
  j <- 0
  for(age in 18:80){
    j <- j+1
    customer$Age <- age
    if(Edu_ == F){customer$Edu <- runif(1)<p_iter_edu[age]
    }else{customer$Edu = T}
    if(Mar_ == F){customer$Mar <- runif(1)<p_iter_mar[age]
    }else{customer$Mar = T}
    customer$Inc <- f_income_evol(age, Edu_, Inc_, guy_trend)

    if(Checking_ == F){customer$Checking <- runif(1)<p_iter_chk[age]
    }else{customer$Checking = T}
    
    if(MM_ == F){customer$MM <- runif(1)<p_iter_mm[age]
    }else{customer$MM = T}
    
    if(Mortgage_ == F){
      if(REStat_ != 'Owner'){
        if(customer$Mortgage <- runif(1)<p_iter_mortgage[age]){
          customer$Mortgage <- T
        }
      }else{customer$Mortgage = F}
    }else{customer$Mortgage = T}
    
    if(Home_eq_ == F){
      if((ChAge_>0) & (REStat_ == 'Owner')){
        customer$Home_eq <- runif(1)<p_iter_home_eq[ChAge_]
      }else{
        customer$Home_eq <- F
      }
    }else{customer$Home_eq = T}
    
		if(customer$CC == F){
      customer$CC <- runif(1)<p_iter_cc[age]
    }else{customer$CC = T}
		
    if(customer$StLoan == F){
      customer$StLoan <- runif(1)<p_iter_stloan[age]
    }else{customer$StLoan = T}
		
		customer$WorkExp <- f_work_exp(WorkExp_, Edu_, age)
		
    customer$ChNum <- f_ch_num(ChNum_, customer$Mar, age)
    if(customer$ChNum > 0){
      ChAge_ <- ChAge_ + 1
      customer$ChAge <- ChAge_
    }
    
    customer$SocialStat <- f_soc_stat(Edu_, age, customer$SocialStat)
    
    customer$REStat <- f_real_est(Edu_, age, REStat_, Mar_, customer$Mortgage)
    if(((customer$REStat == 'Owner') & (REStat_ != 'Owner')) | ((Home_eq_ == F) & (customer$Home_eq == T))){
      spendings <- T
    }else{
      spendings <- F
    }
    
    customer$Traveled <- f_travel()
    
    customer$pChecking <- f_p_checking(customer$Checking, Inc_)
    customer$pMM <- f_p_mm(customer$MM, Inc_, spendings, customer$pMM)
    customer$pMortgage <- f_p_mortgage(customer$Mortgage, Inc_, customer$pMortgage, customer$ypMortgage)
    customer$pHome_eq <- f_p_home_eq(Home_eq_, Inc_, customer$pHome_eq, customer$ypHome_eq)
    customer$pCC <- f_p_cc(customer$CC, Inc_, customer$pCC, customer$ypCC)
    customer$pStLoan <- f_p_stloan(customer$StLoan, Inc_, customer$pStLoan, customer$ypStLoan)
    
    customer$ypChecking <- customer$ypChecking + customer$Checking
    customer$ypMM <- customer$ypMM + customer$MM
    customer$ypMortgage <- customer$ypMortgage + customer$Mortgage
    customer$ypHome_eq <- customer$ypHome_eq + customer$Home_eq
    customer$ypCC <- customer$ypCC + customer$CC
    customer$ypStLoan <- customer$ypStLoan + customer$StLoan
    
    new_acq <- any(customer[products_yp]==1)
    comm <- f_comm_offer(new_acq)
    comm_atrib <- names(comm)
    for(atrib_id in 1:length(comm)){
      customer[comm_atrib[atrib_id]] <- comm[comm_atrib[atrib_id]]
    }
    
    customers[j,names(customer)] <- as.data.frame(customer)
    
    stop_flg <- runif(1) < p_iter_ca[age]
    if(stop_flg){
      break
    }

    Edu_ <- customer$Edu
    Mar_ <- customer$Mar
    Inc_ <- customer$Inc
    ChNum_ <- customer$ChNum
    WorkExp_ <- customer$WorkExp
    REStat_ <- customer$REStat
    
    Checking_ <- customer$Checking
    MM_ <- customer$MM
    Mortgage_ <- customer$Mortgage
    Home_eq_ <- customer$Home_eq
  }
  
  next_id <- rep(F, length(products))
  fp <- rep(0, length(products))
  
  j_ <- j
  for(age in 1:j){
    customer <- customers[j_,]
    customers[j_,products_n] <- next_id
    fp <- fp+customers[j_,products_p]
    customers[j_,products_fp] <- fp
    
    oi_new <- customer[products_yp]==1
    if(any(oi_new)){
      next_id <- oi_new
    }
    j_ <- j_-1
  }
  
  customers_id <- apply(customers[,products], 1, any)
  
	if(any(customers_id)){
    if(real_customer_id==1){
			customers[,logical_id] <- customers[,logical_id]+0
			customers[j, "Id"] <- real_customer_id
			write.table(customers[j,], file = file_name, append = F, quote = TRUE, sep = ",",
                eol = "\n", na = "NA", dec = ".", row.names = F,
                col.names = TRUE, qmethod = c("escape", "double"),
                fileEncoding = "")
      real_customer_id <- real_customer_id+1
		}else{
      customers[,logical_id] <- customers[,logical_id]+0
      customers[j, "Id"] <- real_customer_id
      real_customer_id <- real_customer_id+1
      write.table(customers[j,], file = file_name, append = TRUE, quote = TRUE, sep = ",",
                  eol = "\n", na = "NA", dec = ".", row.names = F,
                  col.names = FALSE, qmethod = c("escape", "double"),
                  fileEncoding = "")
    }
  }
}

# customers

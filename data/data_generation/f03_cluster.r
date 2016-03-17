# checking mm cc mortg home_eq stud_loan
# phone, mail, tellers

f_comm_offer <- function(new_acq){
  comm <- alist()
  
  comm$mail_offer <- runif(1) < 0.1
  comm$phone_offer <- runif(1) < 0.3
  comm$email_offer <- runif(1) < 0.5

  comm$mail_acq <- F
  comm$phone_acq <- F
  comm$email_acq <- F
  
  resp_probs <- c(0.05, 0.4, 0.5)
  
  comm$mail_resp <- ifelse(comm$mail_offer, runif(1)<resp_probs[1], F)
  comm$phone_resp <- ifelse(comm$phone_offer, runif(1)<resp_probs[2], F)
  comm$email_resp <- ifelse(comm$email_offer, runif(1)<resp_probs[3], F)
  
  if(new_acq){
    prod_name <- c("mail_acq", "phone_acq", "email_acq")
    prod_id <- as.numeric(cut(runif(1), cumsum(c(0,resp_probs))/sum(resp_probs), (1:3)))
    comm[prod_name[prod_id]] <- T
  }
  return(comm)
}

f_travel <- function(f_travel){
  return(runif(1)<0.6)
}

f_p_cc <- function(CC, inc, pCC, ypCC){
  if(CC){
    profit <- round(inc/10*(1+rnorm(1)/1))/100
  }else{
    profit <- 0
  }
  return(profit)
}

f_p_stloan <- function(StLoan, inc, pStLoan, ypStLoan){
  if(ypStLoan<6){
    profit <- 0
  }else if(ypStLoan < 16){
    profit <- 250*(1+rnorm(1)/3)
  }else{
    if(runif(1)<0.5){
      profit <- 0
    }
  }
}

f_p_checking <- function(Checking, inc){
  if(Checking){
    profit <- round(inc/5*(1+rnorm(1)/3))/100
  }else{
    profit <- 0
  }
}

f_p_mm <- function(MM, inc, spendings, profit_){
  if(MM){
    if ((profit_ == 0) | (spendings)){
      profit <- inc/400*(1+rnorm(1)/5)
      profit <- round(profit*100)/100
    }else{
      profit <- profit_*(1 + 0.01 + inc/1e7 + rnorm(1)/30)
      profit <- round(profit*100)/100
    }
  }else{
    profit <- 0
  }
}

f_p_mortgage <- function(mortg, inc, profit_, years_past){
  if(years_past>30){
    profit <- 0
    return(profit)
  }
  if(mortg){
    if (profit_ == 0){
      profit <- inc/200*(1+rnorm(1)/6)
      profit <- round(profit*100)/100
    }else{
      profit <- profit_*(1 - 0.03)
      profit <- round(profit*100)/100
    }
  }else{
    profit <- 0
  }
  profit
}

f_p_home_eq <- function(Home_eq, inc, profit_, years_past){
  if(years_past>10){
    profit <- 0
    return(profit)
  }

  if(Home_eq){
    if (profit_ == 0){
      profit <- inc/100*(1+rnorm(1)/6)
      profit <- round(profit*100)/100
    }else{
      profit <- profit_*(1 - 0.02)
      profit <- round(profit*100)/100
    }
  }else{
    profit <- 0
  }
  profit
}

f_real_est <- function(Edu_, Age, REStat_, Mar_, mortg){
  REStat <- REStat_
  if(mortg){
    REStat <- 'Owner'
    return(REStat)
  }
  if(REStat_ == 'Lives_with_relatives'){
    age_move_prob <- c(0.01, 0.01, 0.01, 0.03, 0.1, 0.1, 1)
    if(runif(1) < age_move_prob[Age-17]){
      REStat <- 'Rent'
    }
  }
  if(REStat_ == 'Rent'){
      if(Mar_){
        if(runif(1) < 0.2){
          REStat <- 'Owner'
        }
      }else{
        if(runif(1) < 0.05){
          REStat <- 'Owner'
      }
    }
  }
  REStat
}

f_ch_num <- function(ChNum_, mar, age){
  if(!mar){
    ChNum <- 0
  }else{
    probs <- c(0.3, 0.2, 0.02, 0.01, 0.01, 0.01, 0.01, 0)
    prob <- probs[ChNum_+1]
    if(age>50){
      prob <- 0
    }else if(age>45){
      prob <- prob/2
    }
    
    if (runif(1) < prob){
      ChNum <- ChNum_+1
    }else{
      ChNum <- ChNum_
    }
  }
}

f_work_exp <- function(WorkExp_, edu, age){
  if (edu == 1){
    if (age < 65){
      WorkExp <- WorkExp_+1
    }else{
      WorkExp <- WorkExp_
    }
  }else{
    WorkExp <- 0
  }
}

f_soc_stat <- function(edu, age, stat){
  if(!edu & age < 26){
    stat <- "Student"
  }else{
    if(stat != "Self-Employed"){
      if(runif(1)>0.1){
        stat <- "Employed"
      }else{
        stat <- "Self-Employed"
      }
    }else{
      if(runif(1)>0.9){
        stat <- "Employed"
      }else{
        stat <- "Self-Employed"
      }
    }
  }
  if(age > 65){
    stat <- "Retired"
  }
  return(stat)
}

f_stloan_prob <- function(){
  age_ <- 1:100
  m <- 3
  offset <- 15
  pow <- 10
  
  pdf <- exp(-(age_-offset)*m)*((age_-offset)*m)^pow
  pdf[age_<offset] <- 0
  pdf <- pdf/sum(pdf)
  pdf[pdf<0.001] <- 0
  pdf <- pdf/sum(pdf)*0.4
  
#   plot(pdf)
  return(pdf)
}

f_cc_prob <- function(){
  age_ <- 1:100
  m <- 1
  offset <- 15
  pow <- 10
  
  pdf <- exp(-(age_-offset)*m)*((age_-offset)*m)^pow
  pdf[age_<offset] <- 0
  pdf <- pdf/sum(pdf)
  pdf[pdf<0.001] <- 0
  pdf <- pdf/sum(pdf)*0.2
  
#   plot(pdf)
  return(pdf)
}

f_checking_prob <- function(){
  age_ <- 1:100
  m <- 1
  offset <- 18
  pow <- 10
  
  pdf <- exp(-(age_-offset)*m)*((age_-offset)*m)^pow
  pdf[age_<offset] <- 0
  pdf <- pdf/sum(pdf)
  pdf[pdf<0.001] <- 0
  pdf <- pdf/sum(pdf)*0.9
#   plot(pdf)
  return(pdf)
}

f_mm_prob <- function(){
  age_ <- 1:100
  m <- 1
  offset <- 25
  pow <- 10
  
  pdf <- exp(-(age_-offset)*m)*((age_-offset)*m)^pow
  pdf[age_<offset] <- 0
  pdf <- pdf/sum(pdf)
  pdf[pdf<0.001] <- 0
  pdf <- pdf/sum(pdf)*0.7
#   plot(pdf)
  return(pdf)
}

f_mortgage_prob <- function(){
  age_ <- 1:100
  m <- 1
  offset <- 20
  pow <- 10
  
  pdf <- exp(-(age_-offset)*m)*((age_-offset)*m)^pow
  pdf[age_<offset] <- 0
  pdf <- pdf/sum(pdf)
  pdf[pdf<0.0001] <- 0
  pdf <- pdf/sum(pdf)*0.7
#   plot(pdf)
  return(pdf)
}

f_home_eq_prob <- function(){
  child_age_ <- 1:100
  m <- 1
  offset <- 10
  pow <- 10
  
  pdf <- exp(-(child_age_-offset)*m)*((child_age_-offset)*m)^pow
  pdf[child_age_<offset] <- 0
  pdf <- pdf/sum(pdf)
  pdf[pdf<0.0001] <- 0
  pdf <- pdf/sum(pdf)*0.6
#   plot(pdf)
  return(pdf)
}

f_stop_prob <- function(){
  age <- 1:100
  m <- 1
  offset <- 50
  pow <- 10
  
  pdf <- exp(-(age-offset)*m)*((age-offset)*m)^pow
  pdf[age<offset] <- 0
  pdf <- pdf/sum(pdf)
  pdf[pdf<0.01] <- 0
  pdf <- pdf/sum(pdf)
#   plot(pdf)
  return(pdf)
}

f_edu <- function(){
  age_ <- 1:100
  m <- 5
  offset <- 22
  pow <- 100
  
  pdf <- exp(-(age_*m-offset))*(age_*m-offset)^pow
  pdf[age_<offset] <- 0
  pdf <- pdf/sum(pdf)
  pdf[pdf<0.0001] <- 0
  pdf <- pdf/sum(pdf)*0.7
#   plot(pdf)
  return(pdf)
}

f_mar <- function(){
  age_ <- 1:100
  m <- 0.5
  offset <- 22
  offset2 <- 30
  pow <- 4
  
  pdf <- exp(-((age_-offset)*m))*((age_-offset)*m)^pow
  pdf2 <- exp(-((age_-offset2)*m))*((age_-offset2)*m)^pow
  pdf[age_<offset] <- 0
  pdf2[age_<offset2] <- 0
  pdf <- pdf+pdf2*0.5
  pdf <- pdf/sum(pdf)
  pdf[pdf<0.001] <- 0
  pdf <- pdf/sum(pdf)*0.9
#   plot(pdf)
  return(pdf)
}

f_income_init <- function(n){
  inc <- (rnorm(n)^2+rnorm(n)^2)^0.5
  inc <- round(inc*10)*1000+5000
  return(inc)
#   hist(inc)
}

f_income_evol <- function(age, edu, inc_, trend){
  if(age<25){
    mean_speed <- 2e3
    llim <- 0
    ulim <- 5e4
  }else if(age<30){
    mean_speed <- 1e4
    llim <- 2e4
    ulim <- 15e4
  }else if(age<45){
    mean_speed <- 1e3
    llim <- 2e4
    ulim <- 3e5
  }else if(age<55){
    mean_speed <- -1e3
    llim <- 5e4
    ulim <- 3e5
  }else{
    mean_speed <- -7e3
    llim <- 3e4
    ulim <- 2e5
  }
  
  if(edu){
    mean_speed <- mean_speed + 5e3
  }
  
  inc <- inc_ + mean_speed*trend + round(rnorm(1)*2)*1000
  if (inc<0){
    inc <- 0
  }else if(inc<llim){
    inc <- inc_ + abs(round(rnorm(1)*2)*500)
  }else if(inc>ulim){
    inc <- inc_ - abs(round(rnorm(1)*2)*500)
  }
  inc
}

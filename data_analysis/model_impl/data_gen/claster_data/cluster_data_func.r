
get_actius_data <- function(nrow=80000, seed=1){
  set.seed(seed)
  ncol <- 23
  corr.matrix <- (runif(ncol*ncol)>0.9)*0.1+rnorm(ncol*ncol)*0.25
  corr.matrix[(0:(ncol-1))*(ncol+1)+1] <- 0.25
  corr.matrix <- matrix(corr.matrix, ncol=ncol, nrow=ncol)
  
  data.matrix <- matrix(rnorm(nrow*ncol), ncol=ncol)
  
  data.matrix2 <- data.matrix %*% corr.matrix*1
  
  category<-rep(1,nrow)
  geo.us <-pmax(0,100-data.matrix2[,1]^2)
  geo.eu <-pmax(0,data.matrix2[,2]^2)
  geo.asia <-pmax(0,(data.matrix2[,3]*1)^2)
  geo.africa <-pmax(0,(data.matrix2[,4]*0.1)^2)
  curr.usd <-pmax(0,(data.matrix2[,5]*3+85))
  curr.eu <-pmax(0,data.matrix2[,6]*3+7)
  curr.other <-pmax(0,data.matrix2[,7]*3-2)
  type.exch <-pmax(0,data.matrix2[,8]*3+4)
  type.transf <-pmax(0,data.matrix2[,9]*2)
  type.buy <-pmax(0,data.matrix2[,10]*3+90)
  type.other <-pmax(0,data.matrix2[,11]*3+7)
  method.atm <-pmax(0,data.matrix2[,12]*4+5)
  method.card <-pmax(0,data.matrix2[,13]*5+11)
  method.ecom <-pmax(0,data.matrix2[,14]*4+80)
  method.webbank <-pmax(0,data.matrix2[,15]*3+30)
  method.mobile <-pmax(0,data.matrix2[,16]*3+10)
  dest.mixed <-pmax(0,data.matrix2[,17]*3+50)
  dest.tech <-pmax(0,data.matrix2[,18]*2+10)
  dest.restaurants<-pmax(0,data.matrix2[,19]*3+15)
  dest.grocery <-pmax(0,data.matrix2[,20]*4+22)
  dest.serv <-pmax(0,data.matrix2[,21]*1.5-3)
  dest.travel <-pmax(0,data.matrix2[,22]*2-3)
  dest.other <-pmax(0,data.matrix2[,23]*3+10)
  
  sumv <- geo.us 
  sumv <-sumv+geo.eu 
  sumv <-sumv+geo.asia 
  sumv <-sumv+geo.africa
  sumv <- sumv/100
  geo.us <-geo.us /sumv
  geo.eu <-geo.eu /sumv
  geo.asia <-geo.asia /sumv
  geo.africa <-geo.africa /sumv
  
  sumv <- curr.usd 
  sumv <-sumv+curr.eu 
  sumv <-sumv+curr.other 
  sumv <- sumv/100
  curr.usd <-curr.usd /sumv
  curr.eu <-curr.eu /sumv 
  curr.other <-curr.other/sumv 
  
  sumv <- type.exch 
  sumv <-sumv+type.transf 
  sumv <-sumv+type.buy 
  sumv <-sumv+type.other 
  sumv <- sumv/100
  type.exch <-type.exch /sumv
  type.transf <-type.transf /sumv
  type.buy <-type.buy /sumv
  type.other <-type.other /sumv
  
  sumv <- method.atm 
  sumv <-sumv+method.card 
  sumv <-sumv+method.ecom 
  sumv <-sumv+method.webbank 
  sumv <-sumv+method.mobile 
  sumv <- sumv/100
  method.atm <-method.atm /sumv
  method.card <-method.card /sumv
  method.ecom <-method.ecom /sumv
  method.webbank <-method.webbank /sumv
  method.mobile <-method.mobile /sumv
  
  sumv <- dest.mixed 
  sumv <-sumv+dest.tech 
  sumv <-sumv+dest.restaurants
  sumv <-sumv+dest.grocery 
  sumv <-sumv+dest.serv 
  sumv <-sumv+dest.travel 
  sumv <-sumv+dest.other 
  sumv <- sumv/100
  dest.mixed <-dest.mixed /sumv
  dest.tech <-dest.tech /sumv
  dest.restaurants<-dest.restaurants /sumv
  dest.grocery <-dest.grocery /sumv
  dest.serv <-dest.serv /sumv
  dest.travel <-dest.travel /sumv
  dest.other <-dest.other /sumv
  
  
  df <- data.frame(
    geo.us =geo.us,
    geo.eu =geo.eu,
    geo.asia =geo.asia,
    geo.africa =geo.africa,
    curr.usd =curr.usd,
    curr.eu =curr.eu, 
    curr.other =curr.other,
    type.exch =type.exch,
    type.transf =type.transf, 
    type.buy =type.buy, 
    type.other =type.other, 
    method.atm =method.atm, 
    method.card =method.card, 
    method.ecom =method.ecom, 
    method.webbank =method.webbank, 
    method.mobile =method.mobile, 
    dest.mixed =dest.mixed, 
    dest.tech =dest.tech, 
    dest.restaurants =dest.restaurants,
    dest.grocery =dest.grocery,
    dest.serv =dest.serv,
    dest.travel =dest.travel,
    dest.other =dest.other
  )
  
  ncol <- 17
  corr.matrix <- (runif(ncol*ncol)>0.9)*0.1+rnorm(ncol*ncol)*0.25
  corr.matrix[(0:(ncol-1))*(ncol+1)+1] <- 0.25
  corr.matrix <- matrix(corr.matrix, ncol=ncol, nrow=ncol)
  
  data.matrix <- matrix(rnorm(nrow*ncol), ncol=ncol)
  
  data.matrix2 <- data.matrix %*% corr.matrix*1
  
  category<-rep(1,nrow)
  commchan.mobileApp <-pmax(0,data.matrix2[,1]*3+40)
  commchan.web <-pmax(0,data.matrix2[,2]*2.5+45)
  commchan.ATM <-pmax(0,(data.matrix2[,3]*0.1)*2+10)
  commchan.phone <-pmax(0,(data.matrix2[,4]*0.1)*1+5)
  dur.lt1m <-pmax(0,(data.matrix2[,5]*5+60))
  dur.lt5m <-pmax(0,data.matrix2[,6]*3+30)
  dur.mt5m <-pmax(0,data.matrix2[,7]*1+3)
  sect.card <-pmax(0,data.matrix2[,8]*3+4)
  sect.account <-pmax(0,data.matrix2[,9]*3+70)
  sect.loan <-pmax(0,data.matrix2[,10]*1+2)
  sect.offers <-pmax(0,data.matrix2[,11]*3+25)
  act.yes <-pmax(0,data.matrix2[,12]*4+60)
  adresp.trav <-pmax(0,data.matrix2[,13]*1+0)
  adresp.clothes <-pmax(0,data.matrix2[,14]*5+30)
  adresp.rest <-pmax(0,data.matrix2[,15]*6+40)
  adresp.car <-pmax(0,data.matrix2[,16]*8+13)
  
  sumv <- commchan.mobileApp 
  sumv <-sumv+commchan.web 
  sumv <-sumv+commchan.ATM 
  sumv <-sumv+commchan.phone
  sumv <- sumv/100
  commchan.mobileApp <-commchan.mobileApp /sumv
  commchan.web <-commchan.web /sumv
  commchan.ATM <-commchan.ATM /sumv
  commchan.phone <-commchan.phone /sumv
  
  sumv <- dur.lt1m 
  sumv <-sumv+dur.lt5m 
  sumv <-sumv+dur.mt5m 
  sumv <- sumv/100
  dur.lt1m <-dur.lt1m /sumv
  dur.lt5m <-dur.lt5m /sumv 
  dur.mt5m <-dur.mt5m/sumv 
  
  sumv <- sect.card 
  sumv <-sumv+sect.account 
  sumv <-sumv+sect.loan 
  sumv <-sumv+sect.offers 
  sumv <- sumv/100
  sect.card <-sect.card /sumv
  sect.account <-sect.account /sumv
  sect.loan <-sect.loan /sumv
  sect.offers <-sect.offers /sumv
  
  df2 <- data.frame(
    commchan.mobileApp =commchan.mobileApp,
    commchan.web =commchan.web,
    commchan.ATM =commchan.ATM,
    commchan.phone =commchan.phone,
    dur.lt1m =dur.lt1m,
    dur.lt5m =dur.lt5m, 
    dur.mt5m =dur.mt5m,
    sect.card =sect.card,
    sect.account =sect.account, 
    sect.loan =sect.loan, 
    sect.offers =sect.offers, 
    act.yes =act.yes, 
    adresp.trav =adresp.trav, 
    adresp.clothes =adresp.clothes, 
    adresp.rest =adresp.rest, 
    adresp.car =adresp.car
  )
  
  df3 <- data.frame(
    category = rep(1,nrow),
    age = runif(nrow)*20+30,
    is.male = runif(nrow)>0.5,
    home_zip = sample(state.name, nrow, T)
  )
  
  res<-list(
    df=cbind(df,df2,df3),
    transaction_names=names(df),
    behavior_names=names(df2),
    pers_names=names(df3)
  )
}


get_traveler_data <- function(nrow=20000, seed=2){
  set.seed(seed)
  ncol <- 23
  corr.matrix <- (runif(ncol*ncol)>0.9)*0.1+rnorm(ncol*ncol)*0.25
  corr.matrix[(0:(ncol-1))*(ncol+1)+1] <- 0.25
  corr.matrix <- matrix(corr.matrix, ncol=ncol, nrow=ncol)
  
  data.matrix <- matrix(rnorm(nrow*ncol), ncol=ncol)
  
  data.matrix2 <- data.matrix %*% corr.matrix*1
  
  category<-rep(1,nrow)
  geo.us <-pmax(0,data.matrix2[,1]*3+20)
  geo.eu <-pmax(0,data.matrix2[,2]*5+70)
  geo.asia <-pmax(0,data.matrix2[,3]*5+7)
  geo.africa <-pmax(0,data.matrix2[,4]*3-2)
  curr.usd <-pmax(0,(data.matrix2[,5]*3+20))
  curr.eu <-pmax(0,data.matrix2[,6]*3+70)
  curr.other <-pmax(0,data.matrix2[,7]*2+20)
  type.exch <-pmax(0,data.matrix2[,8]*3+20)
  type.transf <-pmax(0,data.matrix2[,9]*5+10)
  type.buy <-pmax(0,data.matrix2[,10]*4+70)
  type.other <-pmax(0,data.matrix2[,11]*4+7)
  method.atm <-pmax(0,data.matrix2[,12]*4+5)
  method.card <-pmax(0,data.matrix2[,13]*5+80)
  method.ecom <-pmax(0,data.matrix2[,14]*4+10)
  method.webbank <-pmax(0,data.matrix2[,15]*4+5)
  method.mobile <-pmax(0,data.matrix2[,16]*5)
  dest.mixed <-pmax(0,data.matrix2[,17]*3.5+20)
  dest.tech <-pmax(0,data.matrix2[,18]*4+20)
  dest.restaurants<-pmax(0,data.matrix2[,19]*4+45)
  dest.grocery <-pmax(0,data.matrix2[,20]*4+15)
  dest.serv <-pmax(0,data.matrix2[,21]*4+10)
  dest.travel <-pmax(0,data.matrix2[,22]*4+19)
  dest.other <-pmax(0,data.matrix2[,23]*3+10)
  
  sumv <- geo.us 
  sumv <-sumv+geo.eu 
  sumv <-sumv+geo.asia 
  sumv <-sumv+geo.africa
  sumv <- sumv/100
  geo.us <-geo.us /sumv
  geo.eu <-geo.eu /sumv
  geo.asia <-geo.asia /sumv
  geo.africa <-geo.africa /sumv
  
  sumv <- curr.usd 
  sumv <-sumv+curr.eu 
  sumv <-sumv+curr.other 
  sumv <- sumv/100
  curr.usd <-curr.usd /sumv
  curr.eu <-curr.eu /sumv 
  curr.other <-curr.other/sumv 
  
  sumv <- type.exch 
  sumv <-sumv+type.transf 
  sumv <-sumv+type.buy 
  sumv <-sumv+type.other 
  sumv <- sumv/100
  type.exch <-type.exch /sumv
  type.transf <-type.transf /sumv
  type.buy <-type.buy /sumv
  type.other <-type.other /sumv
  
  sumv <- method.atm 
  sumv <-sumv+method.card 
  sumv <-sumv+method.ecom 
  sumv <-sumv+method.webbank 
  sumv <-sumv+method.mobile 
  sumv <- sumv/100
  method.atm <-method.atm /sumv
  method.card <-method.card /sumv
  method.ecom <-method.ecom /sumv
  method.webbank <-method.webbank /sumv
  method.mobile <-method.mobile /sumv
  
  sumv <- dest.mixed 
  sumv <-sumv+dest.tech 
  sumv <-sumv+dest.restaurants
  sumv <-sumv+dest.grocery 
  sumv <-sumv+dest.serv 
  sumv <-sumv+dest.travel 
  sumv <-sumv+dest.other 
  sumv <- sumv/100
  dest.mixed <-dest.mixed /sumv
  dest.tech <-dest.tech /sumv
  dest.restaurants<-dest.restaurants /sumv
  dest.grocery <-dest.grocery /sumv
  dest.serv <-dest.serv /sumv
  dest.travel <-dest.travel /sumv
  dest.other <-dest.other /sumv
  
  
  df <- data.frame(
    geo.us =geo.us,
    geo.eu =geo.eu,
    geo.asia =geo.asia,
    geo.africa =geo.africa,
    curr.usd =curr.usd,
    curr.eu =curr.eu, 
    curr.other =curr.other,
    type.exch =type.exch,
    type.transf =type.transf, 
    type.buy =type.buy, 
    type.other =type.other, 
    method.atm =method.atm, 
    method.card =method.card, 
    method.ecom =method.ecom, 
    method.webbank =method.webbank, 
    method.mobile =method.mobile, 
    dest.mixed =dest.mixed, 
    dest.tech =dest.tech, 
    dest.restaurants =dest.restaurants,
    dest.grocery =dest.grocery,
    dest.serv =dest.serv,
    dest.travel =dest.travel,
    dest.other =dest.other
  )
  
  ncol <- 17
  corr.matrix <- (runif(ncol*ncol)>0.9)*0.1+rnorm(ncol*ncol)*0.25
  corr.matrix[(0:(ncol-1))*(ncol+1)+1] <- 0.25
  corr.matrix <- matrix(corr.matrix, ncol=ncol, nrow=ncol)
  
  data.matrix <- matrix(rnorm(nrow*ncol), ncol=ncol)
  
  data.matrix2 <- data.matrix %*% corr.matrix*1
  
  category<-rep(1,nrow)
  commchan.mobileApp <-pmax(0,data.matrix2[,1]*3+17)
  commchan.web <-pmax(0,data.matrix2[,2]*6+65)
  commchan.ATM <-pmax(0,(data.matrix2[,3]*0.1)*2+5)
  commchan.phone <-pmax(0,(data.matrix2[,4]*0.1)*5+40)
  dur.lt1m <-pmax(0,(data.matrix2[,5]*3+45))
  dur.lt5m <-pmax(0,data.matrix2[,6]*3+65)
  dur.mt5m <-pmax(0,data.matrix2[,7]*5)
  sect.card <-pmax(0,data.matrix2[,8]*4+25)
  sect.account <-pmax(0,data.matrix2[,9]*4+80)
  sect.loan <-pmax(0,data.matrix2[,10]*4+10)
  sect.offers <-pmax(0,data.matrix2[,11]*2+35)
  act.yes <-pmax(0,data.matrix2[,12]*3+30)
  adresp.trav <-pmax(0,data.matrix2[,13]*2)
  adresp.clothes <-pmax(0,data.matrix2[,14]*2)
  adresp.rest <-pmax(0,data.matrix2[,15]*2)
  adresp.car <-pmax(0,data.matrix2[,16]*2)
  
  sumv <- commchan.mobileApp 
  sumv <-sumv+commchan.web 
  sumv <-sumv+commchan.ATM 
  sumv <-sumv+commchan.phone
  sumv <- sumv/100
  commchan.mobileApp <-commchan.mobileApp /sumv
  commchan.web <-commchan.web /sumv
  commchan.ATM <-commchan.ATM /sumv
  commchan.phone <-commchan.phone /sumv
  
  sumv <- dur.lt1m 
  sumv <-sumv+dur.lt5m 
  sumv <-sumv+dur.mt5m 
  sumv <- sumv/100
  dur.lt1m <-dur.lt1m /sumv
  dur.lt5m <-dur.lt5m /sumv 
  dur.mt5m <-dur.mt5m/sumv 
  
  sumv <- sect.card 
  sumv <-sumv+sect.account 
  sumv <-sumv+sect.loan 
  sumv <-sumv+sect.offers 
  sumv <- sumv/100
  sect.card <-sect.card /sumv
  sect.account <-sect.account /sumv
  sect.loan <-sect.loan /sumv
  sect.offers <-sect.offers /sumv
  
  
  df2 <- data.frame(
    commchan.mobileApp =commchan.mobileApp,
    commchan.web =commchan.web,
    commchan.ATM =commchan.ATM,
    commchan.phone =commchan.phone,
    dur.lt1m =dur.lt1m,
    dur.lt5m =dur.lt5m, 
    dur.mt5m =dur.mt5m,
    sect.card =sect.card,
    sect.account =sect.account, 
    sect.loan =sect.loan, 
    sect.offers =sect.offers, 
    act.yes =act.yes, 
    adresp.trav =adresp.trav, 
    adresp.clothes =adresp.clothes, 
    adresp.rest =adresp.rest, 
    adresp.car =adresp.car
  )
  
  df3 <- data.frame(
    category = rep(1,nrow),
    age = runif(nrow)*25+40,
    is.male = runif(nrow)>0.2,
    home_zip = sample(state.name, nrow, T)
  )
  
  res<-list(
    df=cbind(df,df2,df3),
    transaction_names=names(df),
    behavior_names=names(df2),
    pers_names=names(df3)
  )
}


get_pshop_data <- function(nrow=8000, seed=3){
  set.seed(seed)
  ncol <- 23
  corr.matrix <- (runif(ncol*ncol)>0.9)*0.1+rnorm(ncol*ncol)*0.25
  corr.matrix[(0:(ncol-1))*(ncol+1)+1] <- 0.25
  corr.matrix <- matrix(corr.matrix, ncol=ncol, nrow=ncol)
  
  data.matrix <- matrix(rnorm(nrow*ncol), ncol=ncol)
  
  data.matrix2 <- data.matrix %*% corr.matrix*1
  
  category<-rep(1,nrow)
  geo.us <-pmax(0,data.matrix2[,1]*3+70)
  geo.eu <-pmax(0,data.matrix2[,2]*2+17)
  geo.asia <-pmax(0,data.matrix2[,3]*4)
  geo.africa <-pmax(0,data.matrix2[,4]*2)
  curr.usd <-pmax(0,(data.matrix2[,5]*3+70))
  curr.eu <-pmax(0,data.matrix2[,6]*3+17)
  curr.other <-pmax(0,data.matrix2[,7]*6)
  type.exch <-pmax(0,data.matrix2[,8]*2)
  type.transf <-pmax(0,data.matrix2[,9])
  type.buy <-pmax(0,data.matrix2[,10]*2+93)
  type.other <-pmax(0,data.matrix2[,11]*3)
  method.atm <-pmax(0,data.matrix2[,12]*4)
  method.card <-pmax(0,data.matrix2[,13]*4+70)
  method.ecom <-pmax(0,data.matrix2[,14]*3+20)
  method.webbank <-pmax(0,data.matrix2[,15]*1+5)
  method.mobile <-pmax(0,data.matrix2[,16]-1)
  dest.mixed <-pmax(0,data.matrix2[,17]*4+60)
  dest.tech <-pmax(0,data.matrix2[,18]-2)
  dest.restaurants<-pmax(0,data.matrix2[,19]*3+10)
  dest.grocery <-pmax(0,data.matrix2[,20]*2+23)
  dest.serv <-pmax(0,data.matrix2[,21]*2+40)
  dest.travel <-pmax(0,data.matrix2[,22]*3+15)
  dest.other <-pmax(0,data.matrix2[,23]*3-2)
  
  sumv <- geo.us 
  sumv <-sumv+geo.eu 
  sumv <-sumv+geo.asia 
  sumv <-sumv+geo.africa
  sumv <- sumv/100
  geo.us <-geo.us /sumv
  geo.eu <-geo.eu /sumv
  geo.asia <-geo.asia /sumv
  geo.africa <-geo.africa /sumv
  
  sumv <- curr.usd 
  sumv <-sumv+curr.eu 
  sumv <-sumv+curr.other 
  sumv <- sumv/100
  curr.usd <-curr.usd /sumv
  curr.eu <-curr.eu /sumv 
  curr.other <-curr.other/sumv 
  
  sumv <- type.exch 
  sumv <-sumv+type.transf 
  sumv <-sumv+type.buy 
  sumv <-sumv+type.other 
  sumv <- sumv/100
  type.exch <-type.exch /sumv
  type.transf <-type.transf /sumv
  type.buy <-type.buy /sumv
  type.other <-type.other /sumv
  
  sumv <- method.atm 
  sumv <-sumv+method.card 
  sumv <-sumv+method.ecom 
  sumv <-sumv+method.webbank 
  sumv <-sumv+method.mobile 
  sumv <- sumv/100
  method.atm <-method.atm /sumv
  method.card <-method.card /sumv
  method.ecom <-method.ecom /sumv
  method.webbank <-method.webbank /sumv
  method.mobile <-method.mobile /sumv
  
  sumv <- dest.mixed 
  sumv <-sumv+dest.tech 
  sumv <-sumv+dest.restaurants
  sumv <-sumv+dest.grocery 
  sumv <-sumv+dest.serv 
  sumv <-sumv+dest.travel 
  sumv <-sumv+dest.other 
  sumv <- sumv/100
  dest.mixed <-dest.mixed /sumv
  dest.tech <-dest.tech /sumv
  dest.restaurants<-dest.restaurants /sumv
  dest.grocery <-dest.grocery /sumv
  dest.serv <-dest.serv /sumv
  dest.travel <-dest.travel /sumv
  dest.other <-dest.other /sumv
  
  
  df <- data.frame(
    geo.us =geo.us,
    geo.eu =geo.eu,
    geo.asia =geo.asia,
    geo.africa =geo.africa,
    curr.usd =curr.usd,
    curr.eu =curr.eu, 
    curr.other =curr.other,
    type.exch =type.exch,
    type.transf =type.transf, 
    type.buy =type.buy, 
    type.other =type.other, 
    method.atm =method.atm, 
    method.card =method.card, 
    method.ecom =method.ecom, 
    method.webbank =method.webbank, 
    method.mobile =method.mobile, 
    dest.mixed =dest.mixed, 
    dest.tech =dest.tech, 
    dest.restaurants =dest.restaurants,
    dest.grocery =dest.grocery,
    dest.serv =dest.serv,
    dest.travel =dest.travel,
    dest.other =dest.other
  )
  
  ncol <- 17
  corr.matrix <- (runif(ncol*ncol)>0.9)*0.1+rnorm(ncol*ncol)*0.25
  corr.matrix[(0:(ncol-1))*(ncol+1)+1] <- 0.25
  corr.matrix <- matrix(corr.matrix, ncol=ncol, nrow=ncol)
  
  data.matrix <- matrix(rnorm(nrow*ncol), ncol=ncol)
  
  data.matrix2 <- data.matrix %*% corr.matrix*1
  
  category<-rep(1,nrow)
  commchan.mobileApp <-pmax(0,data.matrix2[,1]-2)
  commchan.web <-pmax(0,data.matrix2[,2]*2.5+65)
  commchan.ATM <-pmax(0,(data.matrix2[,3]*0.1)*2+10)
  commchan.phone <-pmax(0,(data.matrix2[,4]*0.1)*1+30)
  dur.lt1m <-pmax(0,(data.matrix2[,5]*5+10))
  dur.lt5m <-pmax(0,data.matrix2[,6]*3+20)
  dur.mt5m <-pmax(0,data.matrix2[,7]*4+30)
  sect.card <-pmax(0,data.matrix2[,8]*3+40)
  sect.account <-pmax(0,data.matrix2[,9]*3+30)
  sect.loan <-pmax(0,data.matrix2[,10]*1+15)
  sect.offers <-pmax(0,data.matrix2[,11]*3+35)
  act.yes <-pmax(0,data.matrix2[,12]*4+10)
  adresp.trav <-pmax(0,data.matrix2[,13]*1+40)
  adresp.clothes <-pmax(0,data.matrix2[,14]*5+80)
  adresp.rest <-pmax(0,data.matrix2[,15]*6+40)
  adresp.car <-pmax(0,data.matrix2[,16]*3+13)
  
  sumv <- commchan.mobileApp 
  sumv <-sumv+commchan.web 
  sumv <-sumv+commchan.ATM 
  sumv <-sumv+commchan.phone
  sumv <- sumv/100
  commchan.mobileApp <-commchan.mobileApp /sumv
  commchan.web <-commchan.web /sumv
  commchan.ATM <-commchan.ATM /sumv
  commchan.phone <-commchan.phone /sumv
  
  sumv <- dur.lt1m 
  sumv <-sumv+dur.lt5m 
  sumv <-sumv+dur.mt5m 
  sumv <- sumv/100
  dur.lt1m <-dur.lt1m /sumv
  dur.lt5m <-dur.lt5m /sumv 
  dur.mt5m <-dur.mt5m/sumv 
  
  sumv <- sect.card 
  sumv <-sumv+sect.account 
  sumv <-sumv+sect.loan 
  sumv <-sumv+sect.offers 
  sumv <- sumv/100
  sect.card <-sect.card /sumv
  sect.account <-sect.account /sumv
  sect.loan <-sect.loan /sumv
  sect.offers <-sect.offers /sumv
  
  
  df2 <- data.frame(
    commchan.mobileApp =commchan.mobileApp,
    commchan.web =commchan.web,
    commchan.ATM =commchan.ATM,
    commchan.phone =commchan.phone,
    dur.lt1m =dur.lt1m,
    dur.lt5m =dur.lt5m, 
    dur.mt5m =dur.mt5m,
    sect.card =sect.card,
    sect.account =sect.account, 
    sect.loan =sect.loan, 
    sect.offers =sect.offers, 
    act.yes =act.yes, 
    adresp.trav =adresp.trav, 
    adresp.clothes =adresp.clothes, 
    adresp.rest =adresp.rest, 
    adresp.car =adresp.car
  )
  
  df3 <- data.frame(
    category = rep(1,nrow),
    age = runif(nrow)*20+20,
    is.male = runif(nrow)>0.83,
    home_zip = sample(state.name, nrow, T)
  )
  
  res<-list(
    df=cbind(df,df2,df3),
    transaction_names=names(df),
    behavior_names=names(df2),
    pers_names=names(df3)
  )
}


get_cbo_data <- function(nrow=50000, seed=4){
  set.seed(seed)
  ncol <- 23
  corr.matrix <- (runif(ncol*ncol)>0.9)*0.1+rnorm(ncol*ncol)*0.25
  corr.matrix[(0:(ncol-1))*(ncol+1)+1] <- 0.25
  corr.matrix <- matrix(corr.matrix, ncol=ncol, nrow=ncol)
  
  data.matrix <- matrix(rnorm(nrow*ncol), ncol=ncol)
  
  data.matrix2 <- data.matrix %*% corr.matrix*1
  
  category<-rep(1,nrow)
  geo.us <-pmax(0,data.matrix2[,1]*3+95)
  geo.eu <-pmax(0,data.matrix2[,2]*2)
  geo.asia <-pmax(0,data.matrix2[,3]*2)
  geo.africa <-pmax(0,data.matrix2[,4]*2)
  curr.usd <-pmax(0,(data.matrix2[,5]*3+95))
  curr.eu <-pmax(0,data.matrix2[,6]*20)
  curr.other <-pmax(0,data.matrix2[,7]*2)
  type.exch <-pmax(0,data.matrix2[,8]*1)
  type.transf <-pmax(0,data.matrix2[,9])
  type.buy <-pmax(0,data.matrix2[,10]*2+97)
  type.other <-pmax(0,data.matrix2[,11]*3)
  method.atm <-pmax(0,data.matrix2[,12]*1)
  method.card <-pmax(0,data.matrix2[,13]*4+95)
  method.ecom <-pmax(0,data.matrix2[,14]*3+5)
  method.webbank <-pmax(0,data.matrix2[,15]*1+5)
  method.mobile <-pmax(0,data.matrix2[,16]*2)
  dest.mixed <-pmax(0,data.matrix2[,17]*4+80)
  dest.tech <-pmax(0,data.matrix2[,18])
  dest.restaurants<-pmax(0,data.matrix2[,19]*3+5)
  dest.grocery <-pmax(0,data.matrix2[,20]*2+10)
  dest.serv <-pmax(0,data.matrix2[,21]*2.5+31)
  dest.travel <-pmax(0,data.matrix2[,22]*3-2)
  dest.other <-pmax(0,data.matrix2[,23]*3-2)
  
  sumv <- geo.us 
  sumv <-sumv+geo.eu 
  sumv <-sumv+geo.asia 
  sumv <-sumv+geo.africa
  sumv <- sumv/100
  geo.us <-geo.us /sumv
  geo.eu <-geo.eu /sumv
  geo.asia <-geo.asia /sumv
  geo.africa <-geo.africa /sumv
  
  sumv <- curr.usd 
  sumv <-sumv+curr.eu 
  sumv <-sumv+curr.other 
  sumv <- sumv/100
  curr.usd <-curr.usd /sumv
  curr.eu <-curr.eu /sumv 
  curr.other <-curr.other/sumv 
  
  sumv <- type.exch 
  sumv <-sumv+type.transf 
  sumv <-sumv+type.buy 
  sumv <-sumv+type.other 
  sumv <- sumv/100
  type.exch <-type.exch /sumv
  type.transf <-type.transf /sumv
  type.buy <-type.buy /sumv
  type.other <-type.other /sumv
  
  sumv <- method.atm 
  sumv <-sumv+method.card 
  sumv <-sumv+method.ecom 
  sumv <-sumv+method.webbank 
  sumv <-sumv+method.mobile 
  sumv <- sumv/100
  method.atm <-method.atm /sumv
  method.card <-method.card /sumv
  method.ecom <-method.ecom /sumv
  method.webbank <-method.webbank /sumv
  method.mobile <-method.mobile /sumv
  
  sumv <- dest.mixed 
  sumv <-sumv+dest.tech 
  sumv <-sumv+dest.restaurants
  sumv <-sumv+dest.grocery 
  sumv <-sumv+dest.serv 
  sumv <-sumv+dest.travel 
  sumv <-sumv+dest.other 
  sumv <- sumv/100
  dest.mixed <-dest.mixed /sumv
  dest.tech <-dest.tech /sumv
  dest.restaurants<-dest.restaurants /sumv
  dest.grocery <-dest.grocery /sumv
  dest.serv <-dest.serv /sumv
  dest.travel <-dest.travel /sumv
  dest.other <-dest.other /sumv
  
  
  df <- data.frame(
    geo.us =geo.us,
    geo.eu =geo.eu,
    geo.asia =geo.asia,
    geo.africa =geo.africa,
    curr.usd =curr.usd,
    curr.eu =curr.eu, 
    curr.other =curr.other,
    type.exch =type.exch,
    type.transf =type.transf, 
    type.buy =type.buy, 
    type.other =type.other, 
    method.atm =method.atm, 
    method.card =method.card, 
    method.ecom =method.ecom, 
    method.webbank =method.webbank, 
    method.mobile =method.mobile, 
    dest.mixed =dest.mixed, 
    dest.tech =dest.tech, 
    dest.restaurants =dest.restaurants,
    dest.grocery =dest.grocery,
    dest.serv =dest.serv,
    dest.travel =dest.travel,
    dest.other =dest.other
  )
  
  ncol <- 17
  corr.matrix <- (runif(ncol*ncol)>0.9)*0.1+rnorm(ncol*ncol)*0.25
  corr.matrix[(0:(ncol-1))*(ncol+1)+1] <- 0.25
  corr.matrix <- matrix(corr.matrix, ncol=ncol, nrow=ncol)
  
  data.matrix <- matrix(rnorm(nrow*ncol), ncol=ncol)
  
  data.matrix2 <- data.matrix %*% corr.matrix*1
  
  category<-rep(1,nrow)
  commchan.mobileApp <-pmax(0,data.matrix2[,1]-2)
  commchan.web <-pmax(0,data.matrix2[,2]*2.5+75)
  commchan.ATM <-pmax(0,(data.matrix2[,3]*0.1)*2+20)
  commchan.phone <-pmax(0,(data.matrix2[,4]*0.1)*1+30)
  dur.lt1m <-pmax(0,(data.matrix2[,5]*5+10))
  dur.lt5m <-pmax(0,data.matrix2[,6]*3+50)
  dur.mt5m <-pmax(0,data.matrix2[,7]*4+10)
  sect.card <-pmax(0,data.matrix2[,8]*4+70)
  sect.account <-pmax(0,data.matrix2[,9]*3+20)
  sect.loan <-pmax(0,data.matrix2[,10]*1+4)
  sect.offers <-pmax(0,data.matrix2[,11]*3+70)
  act.yes <-pmax(0,data.matrix2[,12]*1+10)
  adresp.trav <-pmax(0,data.matrix2[,13]*1+40)
  adresp.clothes <-pmax(0,data.matrix2[,14]*1+2)
  adresp.rest <-pmax(0,data.matrix2[,15]*4+10)
  adresp.car <-pmax(0,data.matrix2[,16]*3+3)
  
  sumv <- commchan.mobileApp 
  sumv <-sumv+commchan.web 
  sumv <-sumv+commchan.ATM 
  sumv <-sumv+commchan.phone
  sumv <- sumv/100
  commchan.mobileApp <-commchan.mobileApp /sumv
  commchan.web <-commchan.web /sumv
  commchan.ATM <-commchan.ATM /sumv
  commchan.phone <-commchan.phone /sumv
  
  sumv <- dur.lt1m 
  sumv <-sumv+dur.lt5m 
  sumv <-sumv+dur.mt5m 
  sumv <- sumv/100
  dur.lt1m <-dur.lt1m /sumv
  dur.lt5m <-dur.lt5m /sumv 
  dur.mt5m <-dur.mt5m/sumv 
  
  sumv <- sect.card 
  sumv <-sumv+sect.account 
  sumv <-sumv+sect.loan 
  sumv <-sumv+sect.offers 
  sumv <- sumv/100
  sect.card <-sect.card /sumv
  sect.account <-sect.account /sumv
  sect.loan <-sect.loan /sumv
  sect.offers <-sect.offers /sumv
  
  
  df2 <- data.frame(
    commchan.mobileApp =commchan.mobileApp,
    commchan.web =commchan.web,
    commchan.ATM =commchan.ATM,
    commchan.phone =commchan.phone,
    dur.lt1m =dur.lt1m,
    dur.lt5m =dur.lt5m, 
    dur.mt5m =dur.mt5m,
    sect.card =sect.card,
    sect.account =sect.account, 
    sect.loan =sect.loan, 
    sect.offers =sect.offers, 
    act.yes =act.yes, 
    adresp.trav =adresp.trav, 
    adresp.clothes =adresp.clothes, 
    adresp.rest =adresp.rest, 
    adresp.car =adresp.car
  )
  
  df3 <- data.frame(
    category = rep(1,nrow),
    age = runif(nrow)*40+20,
    is.male = runif(nrow)>0.4,
    home_zip = sample(state.name, nrow, T)
  )
  
  res<-list(
    df=cbind(df,df2,df3),
    transaction_names=names(df),
    behavior_names=names(df2),
    pers_names=names(df3)
  )
}


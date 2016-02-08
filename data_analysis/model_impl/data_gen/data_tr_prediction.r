

# taxi
# +--------------------------------------------------------
# |features
# |========================================================
# |transactions (within one hour beore target transaction)
# |--------------------------------------------------------
# |
# |type:
# |  1. Airport
# |  2. Restaurant/bar/club
# |  3. Entertaiment
# |
# |time:
# |  1. 7pm-9pm
# |  2. 9pm-11pm
# |  3. 11pm-6am
# |  4. other
# |
# |geo:
# |  1. 0-1mi
# |  2. 1-2mi
# |  3. 2-4mi
# |  4. 4-6mi
# |  5. 6+mi
# |
# |--------------------------------------------------------
# |Social networks
# |--------------------------------------------------------
# |
# |events_types:
# |  1. enteratiment
# |  2. local
# |  3. 
# |  
# |event_time:
# |  1. <30m
# |  2. 30m-1h
# |  3. 1h-2h
# |
# |event_geo:
# |  1. 0-1mi
# |  2. 1-2mi
# |  3. 2-4mi
# |  4. 4-6mi
# |  5. 6+mi
# |
# |checkin_time:
# |  1. 7pm-9pm
# |  2. 9pm-11pm
# |  3. 11pm-6am
# |  4. other
# |
# |checkin_geo:
# |  1. 0-1mi
# |  2. 1-2mi
# |  3. 2-4mi
# |  4. 4-6mi
# |  5. 6+mi
# |
# |--------------------------------------------------------
# |weather
# |--------------------------------------------------------
# |
# |raining:
# |  1. now
# |  2. will be in 1hr
# |
# |temperature
# |  3. >5 degree changes last 1hr
# |  4. 5-10 degree changes last 1hr
# |  5. 10-15 degree changes last 1hr
# |  6. >15 degree changes last 1hr
# |
# +--------------------------------------------------------
#
# +--------------------------------------------------------
# |Scenarios
# |========================================================
# |taxi
# |--------------------------------------------------------
# |
# |
# |
# |
# |
# |
# +--------------------------------------------------------

n <- 10000
n2 <- 1000

tr_attr <- list(
  type = c('airport',
           'rest_bar_club',
           'entertaiment'),
  time = c('7_9',
           '9_11',
           '11_6'),
  geo = c('0_1mi',
          '1_2mi',
          '2_4mi',
          '4_6mi')
)

sn_attr <- list(
  type = c('entert',
           'is.local'),
  time = c('_30m',
           '30m_1h',
           '1h_2h'),
  geo = c('0_1mi',
          '1_2mi',
          '2_4mi',
          '4_6mi'),
  geo_chin = c('0_1mi',
               '1_2mi',
               '2_4mi',
               '4_6mi'),
  time_chin = c('7_9',
                '9_11',
                '11_6')
)

weather_attr <- list(
  rain = c('now',
           'will.be.in.1.hr'),
  temp.changes = c('_5',
                   '5_10',
                   '10_20',
                   '20_')
)

attrs <- list(tr=tr_attr, sn=sn_attr, weather=weather_attr)

for(i in 1:length(attrs)){
  for(j in 1:length(attrs[[i]])){
    tmp <- paste0(
      names(attrs)[[i]],
      '_',
      names(attrs[[i]])[j],
      '_',
      attrs[[i]][[j]]
    )
    attrs[[i]][[j]] <- tmp
  }
}
ns <- unlist(attrs)
names(ns) = NULL


patterns <- list(
  # just came
  p01=list(
    tr_type_airport = 1,
    tr_type_rest_bar_club = 0.5,
    tr_type_entertaiment = 0.1,
    tr_time_7_9 = 2/24,
    tr_time_9_11 = 2/24,
    tr_time_11_6 = 7/24,
    tr_geo_0_1mi = 0,
  	tr_geo_1_2mi = 0.01,
    tr_geo_2_4mi = 0.1,
    tr_geo_4_6mi = 0.3,
    sn_type_entert = 0.01,
    sn_type_is.local = 0,
    sn_time__30m = 0,
    sn_time_30m_1h = 0,
    sn_time_1h_2h = 0.01,
    sn_geo_0_1mi = 0,
    sn_geo_1_2mi = 0,
    sn_geo_2_4mi = 0,
    sn_geo_4_6mi = 0.01,
  	weather_rain_now = 0.1,
    weather_rain_will.be.in.1.hr = 0.1,
    weather_temp.changes__5 = 0.99,
    weather_temp.changes_5_10 = 0.005,
    weather_temp.changes_10_20 = 0.004,
    sn_geo_chin_0_1mi = 0,
    sn_geo_chin_1_2mi = 0,
    sn_geo_chin_2_4mi = 0,
    sn_geo_chin_4_6mi = 0,
    sn_time_chin_7_9 = 0,
    sn_time_chin_9_11 = 0,
    sn_time_chin_11_6 = 0
  ),
  #was somewhere late
  p02=list(
    tr_type_airport = 0,
    tr_type_rest_bar_club = 0.7,
    tr_type_entertaiment = 0.3,
    tr_time_7_9 = 0.1,
    tr_time_9_11 = 0.6,
    tr_time_11_6 = 1,
    tr_geo_0_1mi = 0,
    tr_geo_1_2mi = 0.01,
    tr_geo_2_4mi = 0.4,
    tr_geo_4_6mi = 0.6,
    sn_type_entert = 0.01,
    sn_type_is.local = 0,
    sn_time__30m = 0,
    sn_time_30m_1h = 0,
    sn_time_1h_2h = 0.01,
    sn_geo_0_1mi = 0,
    sn_geo_1_2mi = 0,
    sn_geo_2_4mi = 0,
    sn_geo_4_6mi = 0.01,
    weather_rain_now = 0,
    weather_rain_will.be.in.1.hr = 0,
    weather_temp.changes__5 = 0.99,
    weather_temp.changes_5_10 = 0.005,
    weather_temp.changes_10_20 = 0.004,
    sn_geo_chin_0_1mi = 0,
    sn_geo_chin_1_2mi = 0,
    sn_geo_chin_2_4mi = 0,
    sn_geo_chin_4_6mi = 0,
    sn_time_chin_7_9 = 0,
    sn_time_chin_9_11 = 0,
    sn_time_chin_11_6 = 0
  ),
  #was somewhere late + rain
  p03=list(
    tr_type_airport = 0,
    tr_type_rest_bar_club = 0.7,
    tr_type_entertaiment = 0.3,
    tr_time_7_9 = 0.5,
    tr_time_9_11 = 0.6,
    tr_time_11_6 = 1,
    tr_geo_0_1mi = 0.1,
    tr_geo_1_2mi = 0.4,
    tr_geo_2_4mi = 0.6,
    tr_geo_4_6mi = 0.6,
    sn_type_entert = 0.02,
    sn_type_is.local = 0.02,
    sn_time__30m = 0,
    sn_time_30m_1h = 0,
    sn_time_1h_2h = 0.01,
    sn_geo_0_1mi = 0,
    sn_geo_1_2mi = 0,
    sn_geo_2_4mi = 0,
    sn_geo_4_6mi = 0.01,
    weather_rain_now = 0.8,
    weather_rain_will.be.in.1.hr = 1,
    weather_temp.changes__5 = 0.5,
    weather_temp.changes_5_10 = 0.3,
    weather_temp.changes_10_20 = 0.1,
    sn_geo_chin_0_1mi = 0,
    sn_geo_chin_1_2mi = 0,
    sn_geo_chin_2_4mi = 0,
    sn_geo_chin_4_6mi = 0,
    sn_time_chin_7_9 = 0,
    sn_time_chin_9_11 = 0,
    sn_time_chin_11_6 = 0
  ),
  #is going to event
  p04=list(
    tr_type_airport = 0,
    tr_type_rest_bar_club = 0.2,
    tr_type_entertaiment = 0.1,
    tr_time_7_9 = 0.1,
    tr_time_9_11 = 0.1,
    tr_time_11_6 = 0.4,
    tr_geo_0_1mi = 0.1,
    tr_geo_1_2mi = 0.4,
    tr_geo_2_4mi = 0.6,
    tr_geo_4_6mi = 0.6,
    sn_type_entert = 0.8,
    sn_type_is.local = 0.2,
    sn_time__30m = 0.4,
    sn_time_30m_1h = 0.8,
    sn_time_1h_2h = 0.4,
    sn_geo_0_1mi = 0.1,
    sn_geo_1_2mi = 0.5,
    sn_geo_2_4mi = 0.5,
    sn_geo_4_6mi = 0.5,
    weather_rain_now = 0.1,
    weather_rain_will.be.in.1.hr = 0.1,
    weather_temp.changes__5 = 0.99,
    weather_temp.changes_5_10 = 0.005,
    weather_temp.changes_10_20 = 0.005,
    sn_geo_chin_0_1mi = 0,
    sn_geo_chin_1_2mi = 0,
    sn_geo_chin_2_4mi = 0,
    sn_geo_chin_4_6mi = 0,
    sn_time_chin_7_9 = 0,
    sn_time_chin_9_11 = 0,
    sn_time_chin_11_6 = 0
  ),
  #check in somhere far from home lately
  p05=list(
    tr_type_airport = 0,
    tr_type_rest_bar_club = 0.05,
    tr_type_entertaiment = 0.05,
    tr_time_7_9 = 0.1,
    tr_time_9_11 = 0.2,
    tr_time_11_6 = 0.8,
    tr_geo_0_1mi = 0.,
    tr_geo_1_2mi = 0.05,
    tr_geo_2_4mi = 0.4,
    tr_geo_4_6mi = 0.8,
    sn_type_entert = 0.2,
    sn_type_is.local = 0.2,
    sn_time__30m = 0,
    sn_time_30m_1h = 0,
    sn_time_1h_2h = 0,
    sn_geo_0_1mi = 0.,
    sn_geo_1_2mi = 0.05,
    sn_geo_2_4mi = 0.4,
    sn_geo_4_6mi = 0.8,
    weather_rain_now = 0.3,
    weather_rain_will.be.in.1.hr = 0.2,
    weather_temp.changes__5 = 0.99,
    weather_temp.changes_5_10 = 0.005,
    weather_temp.changes_10_20 = 0.005,
    sn_geo_chin_0_1mi = 0.,
    sn_geo_chin_1_2mi = 0.05,
    sn_geo_chin_2_4mi = 0.4,
    sn_geo_chin_4_6mi = 0.8,
    sn_time_chin_7_9 = 0.1,
    sn_time_chin_9_11 = 0.2,
    sn_time_chin_11_6 = 0.8
  ),
  p06=list(
    tr_type_airport = 0.01,
    tr_type_rest_bar_club = 0.2,
    tr_type_entertaiment = 0.1,
    tr_time_7_9 = 2/24,
    tr_time_9_11 = 2/24,
    tr_time_11_6 = 7/24,
    tr_geo_0_1mi = 0.4,
    tr_geo_1_2mi = 0.2,
    tr_geo_2_4mi = 0.2,
    tr_geo_4_6mi = 0.15,
    sn_type_entert = 0.05,
    sn_type_is.local = 0.05,
    sn_time__30m = 0.001,
    sn_time_30m_1h = 0.001,
    sn_time_1h_2h = 0.002,
    sn_geo_0_1mi = 0.02,
    sn_geo_1_2mi = 0.02,
    sn_geo_2_4mi = 0.01,
    sn_geo_4_6mi = 0.01,
    weather_rain_now = 0.08,
    weather_rain_will.be.in.1.hr = 0.1,
    weather_temp.changes__5 = 0.99,
    weather_temp.changes_5_10 = 0.005,
    weather_temp.changes_10_20 = 0.005,
    sn_geo_chin_0_1mi = 0.01,
    sn_geo_chin_1_2mi = 0.01,
    sn_geo_chin_2_4mi = 0.02,
    sn_geo_chin_4_6mi = 0.05,
    sn_time_chin_7_9 = 0.02,
    sn_time_chin_9_11 = 0.01,
    sn_time_chin_11_6 = 0.01
  )
)


fill_data <- function(col_names){
  if(length(col_names) == 1){
    data[,col_names] <<- runif(n)<p[col_names]
    return()
  }
  probs <- unlist(p[col_names])
  if(sum(probs) <= 1){
    probs[length(probs)+1] <- 1-sum(probs)
  }else{
    probs <- probs/sum(probs)
  }
  tmp <- sample(1:length(probs), size=n, prob=probs, replace=T)
  
  for(i in 1:length(col_names)){
    data[,col_names[i]] <<- tmp==i
  }
  
  return(data[,col_names])
  
}




p <- patterns[[1]]

fill_data2 <- function(p){
  fill_data('tr_type_airport')
  fill_data(c('tr_type_rest_bar_club', 'tr_type_entertaiment'))
  fill_data(c('tr_time_7_9', 'tr_time_9_11', 'tr_time_11_6'))
  fill_data(c('tr_geo_0_1mi','tr_geo_1_2mi','tr_geo_2_4mi','tr_geo_4_6mi'))
  fill_data(c('sn_type_entert','sn_type_is.local'))
  fill_data(c('sn_time__30m','sn_time_30m_1h','sn_time_1h_2h'))
  fill_data(c("sn_geo_0_1mi","sn_geo_1_2mi","sn_geo_2_4mi","sn_geo_4_6mi"))
  fill_data(c("sn_geo_chin_0_1mi","sn_geo_chin_1_2mi","sn_geo_chin_2_4mi","sn_geo_chin_4_6mi"))
  fill_data(c("sn_time_chin_7_9","sn_time_chin_9_11","sn_time_chin_11_6"))
  fill_data(c("weather_rain_now","weather_rain_will.be.in.1.hr"))
  fill_data(c("weather_temp.changes__5","weather_temp.changes_5_10","weather_temp.changes_10_20","weather_temp.changes_20_"))
  return(data)
}

narr <- c(4000,4000,4000,4000,4000,80000)
n <- narr[1]
data <- matrix(0, nrow=n, ncol=length(ns))
colnames(data) = ns
data2 <- fill_data2(patterns[[1]])

for(i in 2:6){
  n <- narr[i]
  p <- patterns[[i]]
  data <- matrix(0, nrow=n, ncol=length(ns))
  colnames(data) = ns
  data_tmp <- fill_data2(patterns[[i]])
  data2 <- rbind(data2, data_tmp)
}

y <- rep(0,sum(narr))
y[1:sum(narr[1:5])] <- 1
ids <- sample(nrow(data2))
data3 <- data2[ids,]
y3 <- y[ids]

df <- as.data.frame(cbind(data3, y=y3))
f <- as.formula(paste0(
  'y~',paste0(names(df)[1:ncol(df)-1], collapse='+')
))

mdl <- glm(f, family='binomial', df)
y_ <- predict(mdl, df, type = "response")

plot(diff(y_[order(y_)]))

# library(fpc)
# df2 <- dbscan(df[1:1000,-ncol(df)], eps=0.99)
# x <- predict(mdl2,df[1:1000,-ncol(df)])
# plot(x)

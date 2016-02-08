
library("e1071")
library("fpc")

niter <- 20

data <- get_all_customers_data()


# transactions based segmentation
data.pca <- prcomp(data$df[,data$transaction_names])
last_idx <- which(data.pca$sdev/sum(data.pca$sdev)<0.03)[1]

error_metric <- c()
cl <- list()
for(iter in 1:niter){
  cl[[iter]]<-cmeans(data.pca$x[,1:last_idx],4,verbose=TRUE,method="cmeans",m=2)
  error_metric[iter] <- cl[[iter]]$withinerror
}
id <- which.min(error_metric)
cl_tr <- cl[[id]]

plot(data.pca$x[,1], data.pca$x[,2], col=cl_tr$cluster)


# behavior based segmentation
data.pca <- prcomp(data$df[,data$behavior_names])
last_idx <- which(data.pca$sdev/sum(data.pca$sdev)<0.03)[1]

error_metric <- c()
cl <- list()
for(iter in 1:niter){
  cl[[iter]]<-cmeans(data.pca$x[,1:last_idx],4,verbose=TRUE,method="cmeans",m=2)
  error_metric[iter] <- cl[[iter]]$withinerror
}
id <- which.min(error_metric)
cl_bh <- cl[[id]]
#plot(data.pca$x[,1], data.pca$x[,2], col=cl_bh$cluster)

data2 <- cbind(data$df[,data$pers_names],
               data.frame(cl_tr = factor(cl_tr$cluster),
                          cl_bh = factor(cl_bh$cluster)))
data2 <- data2[,-which(names(data2) %in% c("home_zip", "category"))]
min.age <- min(data2[,"age"])
data2[,"age"] <- factor(floor((data2[,"age"]-min.age)/5))


data3 <- as.data.frame(model.matrix(~age+cl_bh+cl_tr+is.male, data2))
data3 <- model.matrix(~age+cl_bh+cl_tr+is.male, data2)

data3.pca <- prcomp(data3[,-1])
last_idx <- which(data3.pca$sdev/sum(data3.pca$sdev)<0.03)[1]

data4 <- cbind(data3[,1], data3.pca$x[,1:last_idx])

#theta <- matrix(rnorm(ncol(data4))/100, ncol=1)
theta <- matrix(rep(0,ncol(data4)), ncol=1)
stepsn <- 300
step_size <- 1000
offersn <- 100
alpha <- 0.0001
accuracy <- rep(0,stepsn)
data_sample <- data4
response <- data$response

for(stepi in 1:stepsn){
  response_p <- sigmoid(data_sample %*% theta)
  if(stepi == 1){
    ids2 <- sample(1:length(response), offersn)
  }else{
    resp_o <- order(-response_p)
    n_model <- round((1-exp(-(stepi)/300))*offersn)
    ids2 <- resp_o[1:n_model]
    ids2 <- c(ids2, sample((n_model+1):length(response), offersn-n_model))
  }
  
  response2 <- response[ids2]
  response_p <- response_p[ids2]
  data_sample2 <- data_sample[ids2,]
  
  data_sample <- data_sample[-ids2,]
  response <- response[-ids2]
  
  error <- response_p-response2
  theta <- theta - alpha*(t(data_sample2)%*%error) - 0.001*theta^2
  accuracy[stepi] <- mean(response2)
  
  print(accuracy[stepi])
}

plot(1:stepsn, cumsum(accuracy)*step_size, ylim=c(1,stepsn*step_size))
points(1:stepsn, (1:stepsn)*step_size, col='green')

plot(1:stepsn, accuracy*step_size, ylim=c(1,step_size))
points(1:stepsn, (1:stepsn)*0+step_size, col='green')

plot(1:stepsn, accuracy*100, ylim=c(0,100),
     xlab = "Minibatch ID",
     ylab = "Response Rate (%)")
grid(nx=5)

save(accuracy, file='online_learning.bin')

# for(stepi in 1:stepsn){
#   ids <- (1:step_size)+step_size*(stepi-1)
#   data_sample <- data4[ids,]
#   response_p <- sigmoid(data_sample %*% theta)
#   response <- data$response[ids]
#   ids2 <- order(-response_p)[1:offersn]
#   response <- response[ids2]
#   response_p <- response_p[ids2]
#   data_sample <- data_sample[ids2,]
#   
#   error <- response_p-response
#   theta <- theta - alpha*(t(data_sample)%*%error)
#   accuracy <- mean(response)
#   
#   print(accuracy)
# }






#plot(data.pca$x[,1], data.pca$x[,2])

data$df <- cbind(data$df, list(cluster_tr=cl$cluster))

data.pca <- prcomp(data$df[,data$behavior_names])
cl<-cmeans(data.pca$x[,1:5],4,verbose=TRUE,method="cmeans",m=2)
#plot(data.pca$x[,1], data.pca$x[,2])
#plot(data.pca$x[,1], data.pca$x[,2], col=cl$cluster)
data$df <- cbind(data$df, list(cluster_bh=cl$cluster))

cl<-dbscan(data.pca$x[1:5000,], eps=15, showplot=T, MinPts = 10, method='hybrid')

setwd()
save(data, file='LM_clusters.bin')

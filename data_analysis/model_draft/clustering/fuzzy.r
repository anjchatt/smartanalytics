library("e1071")
x <- read.csv("../data/data1000.csv", header = TRUE)
data <- x[, -1]
cl<-cmeans(x,5,verbose=TRUE,method="cmeans",m=2)
plotcluster(data, cl$cluster)
#clusplot(data, cl$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)
print(cl)
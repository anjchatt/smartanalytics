library('fpc')
x <- read.csv("../data/data1000.csv", header = TRUE)
data <- x[, -1]
db <- dbscan(data, 10,showplot = 1)

print(db$cluster)
#clust<- table(db$cluster)		
#clust/length(db$cluster)	
#traget <- table(x[,1])
#traget/length(x[,1])
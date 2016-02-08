library('cluster')
x <- read.csv("../data/data1000.csv", header = TRUE)
data <- x[, -1]
clarax <- clara(data, 5)
plotcluster(data, clarax$cluster)
#clusplot(data, cl$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)
#cluster.stats(x, clarax$clustering)
summary(clarax)
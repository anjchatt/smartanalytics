x <- read.csv("../data/data1000.csv", header = TRUE)
data <- x[, -1]
km <- kmeans(data, 5)
plotcluster(data, km$cluster)
#clusplot(data, cl$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)
print(km)
#install.packages("igraph") 
#install.packages("network") 
#install.packages("ndtv")
#install.packages("extrafont")

# Set the working directory to the folder containing the example data
setwd("d:\\projects\\R\\visual\\Data\\") 


# ================ Read the example data ================

nodes <- read.csv("darlene-NODES.csv", header=T, as.is=T)
links <- read.csv("darlene-EDGES.csv", header=T, as.is=T)


# Collapse multiple links of the same type between the same two nodes
# by summing their weights, using aggregate() by "from", "to", & "type":
links <- aggregate(links[,3], links[,-3], sum)
links <- links[order(links$from, links$to),]
colnames(links)[4] <- "weight"
rownames(links) <- NULL


# ================ Plotting networks with igraph ================

library(igraph)



# Converting the data to an igraph object:
net <- graph.data.frame(links, nodes, directed=T) 

colrs <- c("gray90", "tomato", "gold")
V(net)$color <- colrs[V(net)$type]

plot(net,vertex.label=V(net)$name,  edge.arrow.size=.4, vertex.label.color="black")
#plot(net, edge.arrow.size=.2, edge.color="orange",
#    vertex.color="orange", vertex.frame.color="#ffffff",
#     vertex.label=V(net)$name, vertex.label.color="black") 
legend(x=-1.5, y=-1.1, c("University", "Person", "Company"), pch=21,
       col="#777777", pt.bg=colrs, pt.cex=2, cex=.8, bty="n", ncol=1)
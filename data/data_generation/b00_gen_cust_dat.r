
#setwd("/home/biadmin/projects/be/01_customer_db/")
#setwd("D:/Users/gtrofimo/Documents/be/01_customer_db")
ntot <- 1.2e6
portion <- c(0.4,0.4,0.2)


source("f00_general_functions.r")

file_name <- "01_customers_c.csv"
real_customer_id <- 1

n <- ntot*portion[1]
source("f01_cluster.r")
source("b01_cluster.r")

n <- ntot*portion[2]
source("f02_cluster.r")
source("b01_cluster.r")

n <- ntot*portion[3]
source("f03_cluster.r")
source("b01_cluster.r")

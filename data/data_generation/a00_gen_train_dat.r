# This script runs data generation routines.
# It uses functions defined separately for each customer group
# Functions define internal dependencies between customer attributes
# Script generates several rows for each customer which are samples
# of customer's life.


setwd("/home/biadmin/projects/be/01_customer_db/")
#setwd("D:/Users/gtrofimo/Documents/be/01_customer_db")
# Total customers number
ntot <- 1e4
# Portions of each customer group in population
portion <- c(0.4,0.4,0.2)
# discount rate
discount_r <- 0.01

# Some general for customer group functions
source("f00_general_functions.r")

# Number of customers in 1st group
n <- ntot*portion[1]
# output file name
file_name <- "01_customers.csv"
# Unique for each customer group functions defining
source("f01_cluster.r")
# Running data generation script
source("a01_cluster.r")

# Number of customers in 2nd group
n <- ntot*portion[2]
file_name <- "02_customers.csv"
source("f02_cluster.r")
source("a01_cluster.r")

# Number of customers in 3rd group
n <- ntot*portion[3]
file_name <- "03_customers.csv"
source("f03_cluster.r")
source("a01_cluster.r")


cld_file_name <- "customerDataCld.csv"

dataset_label <- "01_tr_"
customerData <- read.csv("01_customers.csv")
source("a01_data_pre_cluster.r")

dataset_label <- "02_tr_"
customerData <- read.csv("02_customers.csv")
source("a01_data_pre_cluster.r")

dataset_label <- "03_tr_"
customerData <- read.csv("03_customers.csv")
source("a01_data_pre_cluster.r")

customerData <- read.csv("01_customers_c.csv")
dataset_label <- "01_cc_"
source("a01_data_pre_cluster.r")

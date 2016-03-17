
products <- c("Checking","MM","Mortgage","Home_eq","CC","StLoan")
# next product names
products_n <- paste0(rep("n", length(products)), products)
# years past since product was acquired
products_yp <- paste0(rep("yp", length(products)), products)
# future product profit
products_fp <- paste0(rep("fp", length(products)), products)
# future product profit for time range
products_fp_ <- c("fp1y_prod", "fp3y_prod", "fp5y_prod", "fp10y_prod", "fp17y_prod", "fp30y_prod")
# product profit
products_p <- paste0(rep("p", length(products)), products)

comm_ch <- c("mail", "phone", "email")
comm_inf <- c(
    paste0(comm_ch, rep("_offer", 3)),
    paste0(comm_ch, rep("_resp", 3)),
    paste0(comm_ch, rep("_acq", 3)))

logical_id <- c(products, products_n, comm_inf, "Traveled", "Mar", "Edu")
customerData[,products_fp_] <- 0
customerData[,'products_fpt'] <- 0

xlim <- nrow(customerData)
customerData[,'products_fpt'] <- rowSums(customerData[,products_fp])


id <- ((((1:xlim)+1)-1)%%xlim)+1
customerData[,products_fp_[1]] <- customerData[id,'products_fpt']
id_ <- customerData[id,'Id'] != customerData[,'Id']
customerData[id_,products_fp_[1]] <- 0

id <- ((((1:xlim)+3)-1)%%xlim)+1
customerData[,products_fp_[2]] <- customerData[id,'products_fpt']
id_ <- customerData[id,'Id'] != customerData[,'Id']
customerData[id_,products_fp_[2]] <- 0

id <- ((((1:xlim)+5)-1)%%xlim)+1
customerData[,products_fp_[3]] <- customerData[id,'products_fpt']
id_ <- customerData[id,'Id'] != customerData[,'Id']
customerData[id_,products_fp_[3]] <- 0

id <- ((((1:xlim)+10)-1)%%xlim)+1
customerData[,products_fp_[4]] <- customerData[id,'products_fpt']
id_ <- customerData[id,'Id'] != customerData[,'Id']
customerData[id_,products_fp_[4]] <- 0

id <- ((((1:xlim)+17)-1)%%xlim)+1
customerData[,products_fp_[5]] <- customerData[id,'products_fpt']
id_ <- customerData[id,'Id'] != customerData[,'Id']
customerData[id_,products_fp_[5]] <- 0

id <- ((((1:xlim)+30)-1)%%xlim)+1
customerData[,products_fp_[6]] <- customerData[id,'products_fpt']
id_ <- customerData[id,'Id'] != customerData[,'Id']
customerData[id_,products_fp_[6]] <- 0


customerData[,logical_id] <- customerData[,logical_id]==1
customerData["Id"] <- customerData["Id"]+0
customerData[,"Age"] <- cut(customerData[,"Age"],
                            c(0, 25, 30, 35, 40, 45, 50, 60 ,70, 1000),
                            labels=c("<25", "25-30", "30-35", "35-40", "40-45", "45-50", "50-60", "60_70", "70<"))
customerData[,"Inc"] <- cut(customerData[,"Inc"],
                            c(0, 5000, 1e4, 15e3, 2e4, 3e4, 4e4, 5e4, 6e4, 8e4, 10e4, 15e4, 2e5, 3e5, 4e5, 5e5, 6e5, 8e5, 10e5, 15e5, 1e8),
                            labels=c("<5k", "5k-10k", "10k-15k", "15k-20k", "20k-30k", "30k-40k",
                                     "40k-50k", "50k-60k", "60k-80k", "80k-100k", "100k-150k",
                                     "150k-200k", "200k-300k", "300k-400k", "400k-500k",
                                     "500k-600k", "600k-800k", "800k-1m", "1m-1.5m", "1.5m<"))
customerData[,"ChNum"] <- cut(customerData[,"ChNum"],
                              c(-1, 0, 1, 3, 5, 20),
                              labels=c("0", "1", "1-3", "4-5", "5<"))
customerData[,"WorkExp"] <- cut(customerData[,"WorkExp"],
                                c(-1, 0, 3, 6, 10, 15, 20, 25, 100),
                                labels=c("-", "0-3", "4-6", "7-10", "11-15", "16-20", "21-25", "26<"))
customerData[,"ChAge"] <- cut(customerData[,"ChAge"],
                              c(-1, 0, 3, 6, 10, 15, 20, 25, 100),
                              labels=c("-", "0-3", "4-6", "7-10", "11-15", "16-20", "21-25", "26<"))
for(prod_i in 1:length(products_yp)){
  f_name <- products_yp[prod_i]
  customerData[,f_name] <- cut(customerData[,f_name],
                               c(-1, 0, 2, 5, 10, 20, 30, 100),
                               labels=c("-", "0-2", "3-5", "6-10", "11-20", "21-30", "30<"))
}

types <- rep("", length(customerData))
for(i in 1:length(types)){
  types[i] <- typeof(customerData[1,i])
}
types[types=="double"] <- "numeric"
types[types=="integer"] <- "character"
types[names(customerData) %in% products_fp] <- "numeric"
types[names(customerData) %in% products_p] <- "numeric"

library(bigr)

# conn  <- bigr.connect(host="bi-hadoop-prod-803.services.dal.bluemix.net", port=7052, user="biblumix", password="cf~C@A1362W9")
conn  <- bigr.connect(host="158.85.101.104", port=7052,  user="biadmin", password="Insign1a123")

customerDataCld <- as.bigr.frame(customerData)
customerData <- bigr.persist(customerDataCld, dataSource="DEL", dataPath=paste0(dataset_label, cld_file_name), header=T,del=",")

customerData <- bigr.frame(dataPath=paste0(dataset_label, "customerDataCld.csv"),
                           dataSource = "DEL",
                           delimiter = ",",
                           header = T,
                           coltypes = types,
                           useMapReduce = T)

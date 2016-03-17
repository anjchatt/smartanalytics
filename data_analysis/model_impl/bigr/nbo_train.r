
#setwd("D:/Users/gtrofimo/Documents/project_files/NBO")
library(bigr)

#conn  <- bigr.connect(host="bi-hadoop-prod-803.services.dal.bluemix.net", port=7052, user="biblumix", password="cf~C@A1362W9")
conn  <- bigr.connect(host="158.85.101.104", port=7052,  user="biadmin", password="Insign1a123")

types <- c("numeric","character","logical","logical","character","character","character","character",
		"character","character","logical","logical","logical","logical","logical","logical",
		"logical","character","character","character","character","character","character","numeric",
		"numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric",
		"numeric","numeric","numeric","logical","logical","logical","logical","logical", 
		"logical","logical","logical","logical","logical","logical","logical","logical", 
		"logical","logical","numeric","numeric","numeric","numeric","numeric","numeric", 
		"numeric")
		
types2 <- c("character","character","character","character","character","logical",
		"character","character","logical","character","numeric","character",
		"character","character","logical","character","character","numeric",
		"character","character","character","numeric","numeric","numeric",
		"character","character","character","character","logical","logical",
		"logical","character","character","character","character","character",
		"character","character","character","character","character","logical",
		"logical","logical","logical","character","character","character",
		"character","character","numeric","numeric","character","character",
		"numeric","character","character")


products <- c("Checking","MM","Mortgage","Home_eq","CC","StLoan")
products_n <- paste0(rep("n", length(products)), products)
products_yp <- paste0(rep("yp", length(products)), products)
products_fp <- paste0(rep("fp", length(products)), products)
products_p <- paste0(rep("p", length(products)), products)
comm_ch <- c("mail", "phone", "email")
comm_inf <- c(
    paste0(comm_ch, rep("_offer", 3)),
    paste0(comm_ch, rep("_resp", 3)),
    paste0(comm_ch, rep("_acq", 3)))

customerData_c <- bigr.frame(dataPath="02_cc_customerDataCld.csv",
                           dataSource = "DEL",
                           delimiter = ",",
                           header = T,
                           coltypes = types2,
                           useMapReduce = T)
customerData1 <- bigr.frame(dataPath="01_tr_customerDataCld.csv",
                           dataSource = "DEL",
                           delimiter = ",",
                           header = T,
                           coltypes = types,
                           useMapReduce = T)
customerData2 <- bigr.frame(dataPath="02_tr_customerDataCld.csv",
                           dataSource = "DEL",
                           delimiter = ",",
                           header = T,
                           coltypes = types,
                           useMapReduce = T)
customerData3 <- bigr.frame(dataPath="03_tr_customerDataCld.csv",
                           dataSource = "DEL",
                           delimiter = ",",
                           header = T,
                           coltypes = types,
                           useMapReduce = T)
customerData <- merge(customerData1, customerData2, all.x=T, all.y=T)
customerData <- merge(customerData, customerData3, all.x=T, all.y=T)

#splits <- bigr.sample(customerData, c(0.7, 0.3))
#class(splits)
#train <- splits[[1]]
#test <- splits[[2]]

spoint <- 1000

train <- customerData[customerData$Id > spoint,]
test <- customerData[customerData$Id <= spoint,]

NBOPrTargets <- products_n
cols <- colnames(train)
fp_col_names <- c("fp1y_prod","fp3y_prod","fp5y_prod","fp10y_prod","fp17y_prod","fp30y_prod","products_fpt")
cols <- cols[!(colnames(train) %in% c(NBOPrTargets, products_fp, products_p, "Id", comm_inf, fp_col_names))]

train_subset <- train[,NBOPrTargets[1]]
test_subset <- test[,NBOPrTargets[1]]

for (i in 2:length(NBOPrTargets)){
  train_subset <- train_subset | (train[,NBOPrTargets[i]])
  test_subset <- test_subset | (test[,NBOPrTargets[i]])
}

model_arr <- c()
customerData_c_ <- c()
loss_arr <- c()
loss2_arr <- c()

for (i in 1:length(NBOPrTargets)){
  cols2 <- c(cols, NBOPrTargets[i])
  
  train_subset2 <- train_subset & (!train[,substr(NBOPrTargets[i],2,20)])
  test_subset2 <- test_subset & (!test[,substr(NBOPrTargets[i],2,20)])
  
  model <- tableApply(data = train[train_subset2, cols2],
                      ##
                      rfunction = function(df, target) {
                        library(glmnet)
                        
                        coln <- colnames(df)
                        coln_c <- coln[coltypes(df)=='character']
                        df[,coln_c] <- lapply(df[,coln_c], factor)
                        
                        coln <- colnames(df)
                        
                        levels(df$SocialStat) = c('Student','Employed','Military','Self-Employed','Retired')
                        levels(df$REStat)= c('Owner','Social_rent','Rent','Lives_with_relatives')
                        levels(df$Age)=c("<25", "25-30", "30-35", "35-40", "40-45", "45-50", "50-60", "60_70", "70<")
                        levels(df$Inc)=c("<5k", "5k-10k", "10k-15k", "15k-20k", "20k-30k", "30k-40k",
                                     "40k-50k", "50k-60k", "60k-80k", "80k-100k", "100k-150k",
                                     "150k-200k", "200k-300k", "300k-400k", "400k-500k",
                                     "500k-600k", "600k-800k", "800k-1m", "1m-1.5m", "1.5m<") 
                        levels(df$ChNum)=c("0", "1", "1-3", "4-5", "5<")
                        levels(df$WorkExp)=c("-", "0-3", "4-6", "7-10", "11-15", "16-20", "21-25", "26<")
                        levels(df$ChAge)=c("-", "0-3", "4-6", "7-10", "11-15", "16-20", "21-25", "26<")
                        ypLevels <- c("-", "0-2", "3-5", "6-10", "11-20", "21-30", "30<")
                        ypCols <- coln[substr(coln,1,2)=='yp']
                        for(i in 1:length(ypCols)){
                          levels(df[,ypCols[i]])=ypLevels
                        }
                      
                        cols <- colnames(df)
                        formula_args <- paste(cols[!(cols %in% c(target, substr(target,2,20), paste('p', substr(target,2,20), sep='')))], collapse= "+")
                        formula_glm <- as.formula(paste(target, formula_args, sep="~"))
                        formula_glm2 <- as.formula(c('~',formula_args))
                        
#                        m <- glm2(formula=formula_glm,
#                                  data=df,
#                                  family=binomial(logit))

                        x <- model.matrix(formula_glm, df)
                        y <- data.matrix(df[,target])
                        y[1] <- T
                        y[2] <- F
                        
                        m <- glmnet(data.matrix(x), y, lambda=0.001, "binomial")
                        
                        list(m, formula_glm2)},,
                      ##
                      NBOPrTargets[i])
  
  model_arr[[i]] <- bigr.pull(model)
  
  preds <- tableApply(data = customerData_c[, cols],
                        rfunction = function(df, model, target) {
                          library(glmnet)

                          coln <- colnames(df)
                          coln_c <- coln[coltypes(df)=='character']
                          df[,coln_c] <- lapply(df[,coln_c], factor)
                                                
                          coln <- colnames(df)
                          
                          levels(df$SocialStat) = c('Student','Employed','Military','Self-Employed','Retired')
                          levels(df$REStat)= c('Owner','Social_rent','Rent','Lives_with_relatives')
                          levels(df$Age)=c("<25", "25-30", "30-35", "35-40", "40-45", "45-50", "50-60", "60_70", "70<")
                          levels(df$Inc)=c("<5k", "5k-10k", "10k-15k", "15k-20k", "20k-30k", "30k-40k",
                                       "40k-50k", "50k-60k", "60k-80k", "80k-100k", "100k-150k",
                                       "150k-200k", "200k-300k", "300k-400k", "400k-500k",
                                       "500k-600k", "600k-800k", "800k-1m", "1m-1.5m", "1.5m<") 
                          levels(df$ChNum)=c("0", "1", "1-3", "4-5", "5<")
                          levels(df$WorkExp)=c("-", "0-3", "4-6", "7-10", "11-15", "16-20", "21-25", "26<")
                          levels(df$ChAge)=c("-", "0-3", "4-6", "7-10", "11-15", "16-20", "21-25", "26<")
                          ypLevels <- c("-", "0-2", "3-5", "6-10", "11-20", "21-30", "30<")
                          ypCols <- coln[substr(coln,1,2)=='yp']
                          for(i in 1:length(ypCols)){
                            levels(df[,ypCols[i]])=ypLevels
                          }
                          
                          m <- bigr.pull(model)
                          m_formula <- m[[2]]
                          m <- m[[1]]
                          x <- model.matrix(m_formula, df)
                          
                          data.frame(predict(m, x, type = "response"))},
                        ,
                        model,
                        NBOPrTargets[i])
  customerData_c_[[i]] <- bigr.pull(preds)
  
}

customerData_c_df <- data.frame(customerData_c_)
names(customerData_c_df) <- products

write.table(customerData_c_df, file="01_nbo_results.csv")
save("model_arr", file="NBO_model_arr.bin")

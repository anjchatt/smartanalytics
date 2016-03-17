
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
types_c <- c("character","character","character","character","character","logical",
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
products_fp_ <- c("fp1y_prod", "fp3y_prod", "fp5y_prod", "fp10y_prod", "fp17y_prod", "fp30y_prod")

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
                           coltypes = types_c,
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

#CLTVTargets <- products_n
CLTVTargets <- products_fp_
cols <- colnames(train)
# leave only needed column
cols <- cols[!(colnames(train) %in% c(CLTVTargets, products_n, "Id", products_fp, comm_inf, "products_fpt", products_p))]

customerData_c_ <- c()
loss_arr <- c()
loss2_arr <- c()

for (i in 1:length(CLTVTargets)){
  cols2 <- c(cols, CLTVTargets[i])
	subset <- train[, CLTVTargets[i]] > 0
    
  model <- tableApply(data = train[subset, cols2],
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
                        
#                        m <- glmnet(data.matrix(x), y, lambda=0.001, family="gaussian")
                        m <- glmnet(data.matrix(x), y, lambda=0.01, family="poisson")
                        
												df_names <- names(df)
												df_names <- df_names[df_names!=target]
												dat_signature <- df[1,df_names]
												
                        list(m, formula_glm2, dat_signature)},,
                      ##
                      CLTVTargets[i])
  
#  model_arr[[i]] <- bigr.pull(model)
  
  preds <- tableApply(data = customerData_c[, cols],
                        rfunction = function(df, model, target) {
                          library(glmnet)
                          
                          m <- bigr.pull(model)
                          dat_signature <- m[[3]]
                          m_formula <- m[[2]]
                          m <- m[[1]]
													
													df_ <- dat_signature
													df_[1:nrow(df), names(df_)] <- df[,names(df_)]
													rownames(df_) = make.names(1:nrow(df_), unique=T)
													
                          x <- model.matrix(m_formula, df_)
                          
                          data.frame(predict(m, x, type = "response"))},
                        ,
                        model,
                        CLTVTargets[i])
  customerData_c_[[i]] <- bigr.pull(preds)
  
}

customerData_c_df <- data.frame(customerData_c_)
names(customerData_c_df) <- CLTVTargets

write.table(customerData_c_df, file="02_cltv_results.csv")
#save("model_arr", file="CLTV_prof_model_arr.bin")

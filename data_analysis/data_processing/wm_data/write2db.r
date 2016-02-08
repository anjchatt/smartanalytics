
library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv,
                 user='biadmin',
                 password='v1krNm2I',
                 host='127.0.0.1',
                 port=8084,
                 dbname='WM')
setwd("D:\\projects\\cg2\\wm_data\\vishal")
filenames <- list.files('tables')

for (fn in filenames){
  fn <- "HighNetWorthInsight.csv"
  fn2 <- paste0('tables/',fn)
  df <- read.table(fn2, header=T, sep = ',')
  dbWriteTable(con, 
               fn,
               value=df,
               overwrite=TRUE,
               row.names=FALSE)
}


# myTable <- data.frame(
#   a=runif(10),
#   b=runif(10)
# )
# 
# dbWriteTable(con, 
#              c('test_table','c'),
#              value=myTable[,1],
#              overwrite=TRUE,
#              row.names=FALSE)
# 
# myTable2 <- dbReadTable(con, "test_table")
# dbExistsTable(con, "test_table")


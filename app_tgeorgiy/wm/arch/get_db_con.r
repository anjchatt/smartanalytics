library(RPostgreSQL)
get_db_con <- function(){
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,
                   user='biadmin',
                   password='v1krNm2I',
                   host='127.0.0.1',
                   port=8084,
                   dbname='WM')
  return(con)
}
#lapply(dbListConnections(drv),dbDisconnect)
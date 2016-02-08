bigrS.host <- "vmk0007.analytics.ibmcloud.com"
bigrS.port <- 7052
bigrS.database <- "default"
bigrS.user <- "biadmin"
bigrS.password <- "v1krNm2I"
settings.filePrefix <- "/poc-data/source"
settings.useMapReduce <- FALSE
data.behaviour.s <- paste(settings.filePrefix, "/behavior/behavior1000000.csv", sep="")
data.behaviour.s_coltypes <- c("integer", rep("numeric", 16))
data.behaviour.dbscan.out <- "behavior.dbscan.bin"
data.behaviour.fuzzy.out <- "behavior.fuzzy.bin"
data.trans.s <- paste(settings.filePrefix, "/transaction/transaction1000000.csv", sep="")
data.trans.s_coltypes <- c("integer", rep("numeric", 23))

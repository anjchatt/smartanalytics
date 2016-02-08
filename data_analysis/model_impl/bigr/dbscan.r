source("initbigr.r") 
air <- bigr.frame(dataSource="DEL", header=TRUE, dataPath=data.behaviour.s, useMapReduce=settings.useMapReduce, coltypes=data.behaviour.s_coltypes)
air$category <- NULL #As we already have category in the source data, remove it
db <- tableApply(air, function(df) {
  library("fpc")
  df.pca <- prcomp(df)
  df<-df.pca$x[,1:5]
  dbscan(df, 10, method='raw')
})

res <- bigr.pull(db)
saveRDS(res, file = data.behaviour.dbscan.out)
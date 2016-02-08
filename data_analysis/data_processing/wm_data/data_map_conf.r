
#user biadmin
#password --
#
#install.packages("RPostgreSQL")
#install.packages("vwr")
library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")
#con <- dbConnect(drv, port=8084, password='123', user='postgres')
con <- dbConnect(drv,
                 user='biadmin',
                 password='v1krNm2I',
                 host='127.0.0.1',
                 port=8084,
                 dbname='WM')


dbExistsTable(con, "HighNetWorthInsight.csv")
hnis <- dbReadTable(con, "HighNetWorthInsight.csv")

hni_names <- gsub('[^a-zA-Z ]', '', hnis$Contact.Name)
hni_names2 <- paste0(' ',hni_names,' ')
hni_name_parts <- strsplit(hni_names, " ", fixed=F)

conf <- dbReadTable(con, "Conferences.csv")
conf_names <- gsub('[^a-zA-Z ]', '', conf$Executive)
conf_names <- gsub(' [A-Z] ', ' ', conf_names)

conf_name_parts <- strsplit(conf_names, " ", fixed=F)

matched <- list()

# for(i in 1:1000){
#   for(j in 1:length(hni_name_parts)){
#     mv <- min(length(am_name_parts[[i]]), length(hni_name_parts[[j]]))
#     if (mv == sum(am_name_parts[[i]] %in% hni_name_parts[[j]])){
#       matched[[i]] <- am_name_parts[i]
#       break
#     }else{
#       matched[[i]] <- c()
#     }
#   }
# }

# tmp_ids <- rep(0, 1000)
# for(i in 1:1000){
#   tmp_flags <- rep(0, length(hni_name_parts))
#   for(j in 1:length(am_name_parts[[i]])){
#     tmp <- paste0(' ',am_name_parts[[i]][j],' ')
#     ids <- grep(tmp, hni_names2)
#     tmp_flags[ids] <- tmp_flags[ids]+1
#   }
#   tmp_id <- which(tmp_flags==length(am_name_parts[[i]]))
#   if(length(tmp_id)>0){
#     tmp_ids[i] <- tmp_id[1]
#   }
# }



hni_name_parts_len <- sapply(hni_name_parts, function(x){length(x)})
hni_name_id_len <- sum(hni_name_parts_len)
hni_name_id <- rep(0, hni_name_id_len)
hni_name_id[cumsum(c(1,hni_name_parts_len[1:(length(hni_name_parts_len)-1)]))] <- 1
hni_name_id <- cumsum(hni_name_id)
hni_name_parts_ul <- unlist(hni_name_parts)

tmp_matches <- rep(0, length(conf_name_parts))
for(i in 1:length(conf_name_parts)){
  tmp_flags <- rep(0, length(hni_name_parts))
  for(j in 1:length(conf_name_parts[[i]])){
    tmp_ids <- hni_name_id[hni_name_parts_ul == conf_name_parts[[i]][j]]
    tmp_flags[tmp_ids] <- tmp_flags[tmp_ids]+1
  }
  tmp_id <- which(tmp_flags==length(conf_name_parts[[i]]))
  if(length(tmp_id)>0){
    tmp_matches[i] <- tmp_id[1]
  }
}

tmp_matches2 <- tmp_matches
# matched_table <- as.data.frame(table(tmp_matches), stringsAsFactors=F)
# tmp_id <- as.numeric(matched_table$tmp_matches[matched_table$Freq != 1])
# tmp_matches2[tmp_matches2 %in% tmp_id] <- 0

conf$client_id <- tmp_matches2


library(RPostgreSQL)
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv,
                 user='biadmin',
                 password='v1krNm2I',
                 host='127.0.0.1',
                 port=8084,
                 dbname='WM')
fn <- "Conferences.csv"
dbWriteTable(con, 
             fn,
             value=conf,
             overwrite=TRUE,
             row.names=FALSE)


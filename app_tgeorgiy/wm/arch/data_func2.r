get_wm_fb_feeds <- function(){


library(jsonlite)

get_text_tax <- function(text){
  url <- paste0('http://gateway-a.watsonplatform.net/calls/text/TextGetCombinedData?',
                'apikey=c53e15d0a29aa87dc4a287e96f28e1134b8f3c7d&',
                'extract=entity,keyword,taxonomy,concept,doc-sentiment&',
                'outputMode=json&',
                'text="',URLencode(text),'"')
  json_data <- fromJSON(paste(readLines(url), collapse=""))
}

facebook_feeds <- list(text=c("Bought my first ever one piece swimsuit today to accommodate my 5 month baby bump. The sales lady helping me at Selfridges couldn't believe I was pregnant and called it \"The perfect baby bump\". Though I feel FAR from it, I was super flattered smile emoticon I wish sales people in the U.A.E. made me feel as good!",
                            "Being pregnant and getting bigger by the second, it's hard to get excited about the new collections this year. But I fell in LOVE with this Halston Heritage gown on Netaporter. It's so dreamy!!! heart emoticon ",
                            "The new model - to be unveiled during 2016 - will sit at the heart of the luxury British brand's range and represents the first major product of the company's bold Second Century Plan.While all technical and design details will be announced in due course, the confirmation of the name - which follows in the footsteps of other iconic Aston Martin sports cars such as the DB5 and DB9 - signals the start of an exciting period of dynamic product development by the company.Announcing the DB11, Aston Martin CEO Dr Andy Palmer said: \"Today I am proud and pleased to confirm that the DB11 nameplate will sit on our next new car.\"Not only is it a sign of our intention to continue the long line of iconic sports cars that bear the 'DB' moniker - the very bloodline of our brand - but it also shows the world our ambitious plan in action.\"The coming years will see Aston Martin transform not only its entire range of models but also its scale and global presence, and the new DB11 will be central to that success."),
                        sources=c("https://www.facebook.com/MySmallObsessions/posts/674065199303118",
                              "https://www.facebook.com/MySmallObsessions/posts/684242554952049",
                              "https://www.facebook.com/AstonMartinVancouver/posts/955010391188587"))

facebook_feeds$keywords <- c()
facebook_feeds$sentiment <- c()
taxonomy <- c()

# API query
#   for(i in 1:length(facebook_feeds$text)){
#    response <- get_text_tax(facebook_feeds$text[i])
#    facebook_feeds$keywords[i] <- paste0(response$keywords$text, collapse=", ")
#    facebook_feeds$sentiment[i] <- as.numeric(response$docSentiment$score)
#    taxonomy[i] <- list(response$taxonomy$label)
#   }
file_path <- "fb_data.bin"
#save(facebook_feeds, taxonomy, file=file_path)
load(file=file_path)

tax_file_path <- "../taxonomies.txt"
pre_tax = readLines(tax_file_path)
ntax <- length(pre_tax)/2

tax <- as.list(pre_tax[1:ntax])
names(tax) = pre_tax[(ntax+1):(ntax*2)]


event_flag <- c()
taxonomies2 <- c()
facebook_feeds$categories <- c()
for(i in 1:length(taxonomy)){
  isevent<-taxonomy[[i]] %in% names(tax)
  if(any(isevent)){
    event_flag[i] <- T
    taxonomies2[i] <- taxonomy[[i]][which(isevent)[1]]
  }else{
    event_flag[i] <- F
    taxonomies2[i] <- taxonomy[[i]][1]
  }
  pre_cat <- strsplit(taxonomies2[i],'/')[[1]]
  facebook_feeds$categories[i] <- pre_cat[length(pre_cat)]
}

events <- data.frame(category=facebook_feeds$categories[event_flag],
                     taxonomy=taxonomies2[event_flag],
                     keywords=facebook_feeds$keywords[event_flag],
                     sources= facebook_feeds$sources[event_flag],
                     sentiment=facebook_feeds$sentiment[event_flag],
                     proposed_action=rep('',sum(event_flag)))

rnews <- data.frame(category=facebook_feeds$categories[!event_flag],
                    taxonomy=taxonomies2[!event_flag],
                    keywords=facebook_feeds$keywords[!event_flag],
                    sources=facebook_feeds$sources[!event_flag],
                    sentiment=facebook_feeds$sentiment[!event_flag])

return(list(events=events, rnews=rnews))
}

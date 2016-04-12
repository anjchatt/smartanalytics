get_wm_feeds <- function(){

library(jsonlite)
#json_file <- "D:\\projects\\cg2\\ph2\\ph2\\wm\\a25_Marcel_Smits.json"
#json_file <- "D:\\projects\\cg2\\ph2\\ph2\\wm\\a08_Darlene_Solomon.json"
json_file <- "a08_Darlene_Solomon.json"
json_data <- fromJSON(json_file)

#name <- "Marcel Smits"
name <- "Darlene Solomon"
relevance <- list()
sentiment <- list()
keywords <- list()
sources <- list()
taxonomies <- list()


article_n = length(json_data$result$docs$source$enriched$url$url)

for(i_article in 1:article_n){
	entities <- json_data$result$docs$source$enriched$url$entities[[i_article]]$text
	entity_id <- grep(name, entities, ignore.case=TRUE, fixed=FALSE)
	if (length(entity_id)==0){
		cat('no entity named with client name')
		break
	}
	relevance[i_article] <- json_data$result$docs$source$enriched$url$entities[[i_article]]$relevance[entity_id]
	sentiment[i_article] <- json_data$result$docs$source$enriched$url$entities[[i_article]]$sentiment$score[entity_id]
	pre_keys <- json_data$result$docs$source$enriched$url$concepts[[i_article]]$text
	pre_keys <- pre_keys[is.na(as.numeric(pre_keys))]
	keywords[i_article] <- paste0(pre_keys, collapse=', ')
}
relevance<-sapply(relevance, function(v){v[[1]]})
sentiment<-sapply(sentiment, function(v){v[[1]]})
keywords<-sapply(keywords, function(v){v[[1]]})

sources <- json_data$result$docs$source$enriched$url$url
taxonomies <- json_data$result$docs$source$enriched$url$taxonomy


tax_file_path <- "../taxonomies.txt"
pre_tax = readLines(tax_file_path)
ntax <- length(pre_tax)/2

tax <- as.list(pre_tax[1:ntax])
names(tax) = pre_tax[(ntax+1):(ntax*2)]

event_flag <- c()
taxonomies2 <- c()
categories <- c()
for(i in 1:length(taxonomies)){
  isevent<-taxonomies[[i]]$label %in% names(tax)
  if(any(isevent)){
    event_flag[i] <- T
    taxonomies2[i] <- taxonomies[[i]]$label[which(isevent)[1]]
    pre_cat <- strsplit(taxonomies2[i],'/')[[1]]
    categories[i] <- pre_cat[length(pre_cat)]
  }else{
    event_flag[i] <- F
    taxonomies2[i] <- taxonomies[[i]]$label[1]
    pre_cat <- strsplit(taxonomies2[i],'/')[[1]]
    categories[i] <- pre_cat[length(pre_cat)]
  }
}

events <- data.frame(category=categories[event_flag],
                     taxonomy=taxonomies2[event_flag],
                     keywords=keywords[event_flag],
                     sources=sources[event_flag],
                     sentiment=sentiment[event_flag],
                     proposed_action=rep('',sum(event_flag)))

rnews <- data.frame(category=categories[!event_flag],
                    taxonomy=taxonomies2[!event_flag],
                    keywords=keywords[!event_flag],
                    sources=sources[!event_flag],
                    sentiment=sentiment[!event_flag])

return(list(events=events, rnews=rnews))
}

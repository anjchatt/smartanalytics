find_hni <- function(hni_names, inp){
  hni_names <- gsub('[^a-zA-Z ]', '', hni_names)
  hni_name_parts <- strsplit(hni_names, " ", fixed=F)
  
  inp <- gsub('[^a-zA-Z ]', '', inp)
  inp <- gsub(' [A-Z] ', ' ', inp)
  
  inp_parts <- strsplit(inp, " ", fixed=F)

  hni_name_parts_len <- sapply(hni_name_parts, function(x){length(x)})
  hni_name_id_len <- sum(hni_name_parts_len)
  hni_name_id <- rep(0, hni_name_id_len)
  hni_name_id[cumsum(c(1,hni_name_parts_len[1:(length(hni_name_parts_len)-1)]))] <- 1
  hni_name_id <- cumsum(hni_name_id)
  hni_name_parts_ul <- unlist(hni_name_parts)
  tmp_flags <- rep(0, length(hni_name_parts))
  
  for(j in 1:length(inp_parts[[1]])){
    tmp_ids <- hni_name_id[hni_name_parts_ul == inp_parts[[1]][j]]
    tmp_flags[tmp_ids] <- tmp_flags[tmp_ids]+1
  }
  
  tmp_id <- which(tmp_flags==length(inp_parts[[1]]))
  
  if(length(tmp_id)>0){
    result <- tmp_id[1]
  }else{
    result <- 0
  }
  return(result)
}

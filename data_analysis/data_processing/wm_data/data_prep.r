
setwd("D:\\projects\\cg2\\wm_data\\vishal")
folder_name <- 'tables'

df <- readLines('HNINews.csv')
df <- df[c(-1,-2)]
df <- paste(df, collapse=",")
df <- strsplit(df, "\",\"", fixed=T)[[1]]
df[1] <- substr(df[1],2,1000)

nnews <- length(df)

dates <- date <- substr(df,1,10)
pre_names <- strsplit(df, "\\s\\s\\s", fixed=F)
names <- sapply(pre_names, function(s){s[length(s)]}, USE.NAMES = F)
name_len <- sapply(names, nchar, USE.NAMES = F)
str_len <- sapply(df, nchar, USE.NAMES = F)
df_tmp <- data.frame(data=df, len=str_len-name_len)
text <- apply(df_tmp, 1,
              function(str){substr(str[1], 14, str[2])})
names(text) = NULL

cat_dict <- c(Awa='Award/Recognition', New='New Appointment', Pro='Promotion', Rol='Role Change')
pre_cat <- substr(text,1,3)
cat <- cat_dict[pre_cat]
names(cat) = NULL
pre_cat_len <- sapply(cat, nchar)+2

df_tmp <- data.frame(data=text, len=pre_cat_len)
text <- apply(df_tmp, 1,
               function(str){substr(str[1], str[2], 10000)})

df <- data.frame(
  name=names,
  date=dates,
  news=text,
  news_category=cat)

file <- paste0(folder_name,'/news.csv')
write.table(df, file = file, sep = ",",
            eol = "\n", dec = ".", row.names = F,
            col.names = TRUE, fileEncoding = "")

dt <- read.table('Biography.csv', header=T, sep = ',')


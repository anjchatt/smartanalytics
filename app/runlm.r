#install.packages("shiny")
#install.packages("ggplot2")
library("shiny")
script.dir <- dirname(sys.frame(1)$ofile)

setwd(paste0(script.dir, '/lm'))

path <- getwd()

runApp(appDir = path,
       port = 8082,
       launch.browser=F,
       host = '0.0.0.0')

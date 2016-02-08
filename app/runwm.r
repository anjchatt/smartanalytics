#install.packages("shiny")
#install.packages("ggplot2")
script.dir <- dirname(sys.frame(1)$ofile)

setwd(paste0(script.dir, '/wm'))

path <- getwd()

runApp(appDir = path,
       port = 777,
       launch.browser=F,
       host = '0.0.0.0')

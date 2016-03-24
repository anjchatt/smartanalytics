library(shiny)

path <- 'lm'

print('starting LM app')

runApp(appDir = path,
       port = 8082,
       launch.browser=F,
       host = '0.0.0.0')

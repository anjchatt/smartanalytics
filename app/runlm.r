library(shiny)

path <- '/home/smartanalytics/projects/smartanalytics/app/lm'

print('starting LM app')

runApp(appDir = path,
       port = 8082,
       launch.browser=F,
       host = '0.0.0.0')

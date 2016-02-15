library(shiny)

path <- '/home/smartanalytics/projects/smartanalytics/app/IAP'

print('starting IAP app')

runApp(appDir = path,
       port = 8084,
       launch.browser=F,
       host = '0.0.0.0')

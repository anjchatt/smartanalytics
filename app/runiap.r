library(shiny)

path <- '/home/smartanalytics/projects/1st_ph/IAP'

print('starting IAP app')

runApp(appDir = path,
       port = 8084,
       launch.browser=F,
       host = '0.0.0.0')

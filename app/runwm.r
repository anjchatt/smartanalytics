library(shiny)

path <- '/home/smartanalytics/projects/smartanalytics/app/wm'

print('starting WM app')

runApp(appDir = path,
       port = 8083,
       launch.browser=F,
       host = '0.0.0.0')

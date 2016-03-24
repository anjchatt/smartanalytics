library(shiny)

path <- 'wm'

print('starting WM app')

runApp(appDir = path,
       port = 8083,
       launch.browser=F,
       host = '0.0.0.0')

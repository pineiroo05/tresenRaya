#PRIMER FICHERO QUE SE EJECUTA AL ABRIR LA APLICACION
#carga las librerias usadas, esto tambien lo podria meter en un fichero global.R
#library(shiny)
#library(ggplot2)
source("global.R")

#llamada a iu.R
source("ui.R")

#llamada a server.R
source("server.R")

#ejecucion del juego
shinyApp(iu, server)
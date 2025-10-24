#CODIGO QUE GENERA EL TABLERO DEL JUEGO
iu <- fluidPage(
  titlePanel("3 EN RAYA"),
  fluidRow(
    column(12, plotOutput("tablero", click="turno", height="400px"))
  ),
  h3(textOutput("estado")),
  actionButton("reiniciar", "Reiniciar partida")
)
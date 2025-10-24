#ESTA SERIA LA FUNCION QUE ACTUA DE SERVER EN SHINY, PARA LUEGO PASARSELA A shinyApp()
server <- function(input, output, session){
  tablero <- reactiveVal(matrix(" ", nrow = 3, ncol = 3)) #reactiveVal() es para crear un objeto q uso para leer/escribir un valor
  jugador <- reactiveVal("X")
  fin <- reactiveVal(FALSE)
  
  verGanador<-function(tab){
    #aqui miraria las filas y columnas
    for(i in 1:3){
      if(all(tab[i, ] == "X")) return("X")
      if(all(tab[i, ] == "O")) return("O")
      if(all(tab[, i] == "X")) return("X")
      if(all(tab[, i] == "O")) return("O")
    }
    #aqui miraria las diagonales
    if(all(diag(tab) == "X") || all(diag(tab[, 3:1]) == "X")) return("X")
    if(all(diag(tab) == "O") || all(diag(tab[, 3:1]) == "O")) return("O")
    #realmente en el 3 en raya no hay empate, pero de momento considero q lo hay cuando todos los huecos estan cubiertos. Mas adelante mirare de como arreglarlo
    if(all(tab != " ")) return("Empate")
    return(NULL)
  }
  
  output$tablero <- renderPlot({
    tab <- tablero() #estado del tablero
    data <- expand.grid(x = 1:3, y= 1:3)
    data$label <- as.vector(t(tab))
    
    ggplot(data, aes(x, y))+
      geom_tile(fill = "white", color = "black")+
      geom_text(aes(label = label), size = 10, color = "black")+
      coord_equal()+
      theme_void()+
      scale_y_reverse()
    #El scale es muy importante, ya q si no las posiciones estarían mapeadas al revés, para ggplot el eje de las y estaria al contrario
  })
  
  observeEvent(input$turno, {
    if(fin()) return() #Acabo? -> no hacer nada
    #Ahora convertimos los clicks en las coordenadas donde deben ir las fichas
    # EN FILA HAY Q PONER 4, PQ R INTERPRETA LAS FILAS POR DECIRLO ASI, LO Q PARA NOSOTROS ES LA FILA 1, PARA EL ES LA 3 ENTONCES CUANDO LE HAGO ESA RESTA YA LO ESTAMOS PONIENDO "BIEN"
    fila <- ceiling(input$turno$y)
    columna <- ceiling(input$turno$x)
    if(!(fila %in% 1:3 && columna %in% 1:3)) return()
    
    # Ahora miramos q esa fila no este ocupada
    tab <-tablero()
    if(tab[fila, columna] != " ") return()
    
    #Para actualizar el tablero segun esas coordenadas
    tab[fila, columna] <- jugador()
    tablero(tab)
    
    #Comprobacion para ver si alguien ganó
    #TENDRIA QUE IR VIENDO LAS POSICIONES EN LAS QUE CADA UNO DE LOS JUGADORES PONE SUS FICHAS->GANA EL QUE PONGA SUS 3 FICHAS EN UNA LINEA
    ganador <-verGanador(tab)
    if(!is.null(ganador)){
      fin(TRUE)
      if(ganador == "Empate"){
        output$estado <- renderText("EMPATEE")
      }else{
        output$estado <- renderText(paste("GANO", ganador))
      }
      return()
    }
    
    jugador(ifelse(jugador()=="X", "O", "X"))
    output$estado <- renderText(paste("Turno de", jugador()))
  })
  
  observeEvent(input$reiniciar, {
    tablero(matrix(" ", nrow = 3, ncol = 3))
    jugador("X")
    fin(FALSE)
    output$estado <- renderText("Nuevo juego")
  })
  
  output$estado <- renderText("Nuevo juego")
}
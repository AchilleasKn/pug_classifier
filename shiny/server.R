library(shiny)
library(httr)

shinyServer(function(input, output) {

    output$distPlot <- renderPlot({
        x    <- faithful[, 2]  # Old Faithful Geyser data
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        cat('Hello world!!\n', file = stderr())
        response<-GET('http://flask-api:5000/models/pugs')
        cat(content(response, as="text"), file=stderr())
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
})

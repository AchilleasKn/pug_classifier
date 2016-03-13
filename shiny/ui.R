library(shiny)

shinyUI(fluidPage(
    
    titlePanel("Hello Shiny!"),
    
    sidebarLayout(
        sidebarPanel(
            textInput("img_url", label="Image URL:", value="https://upload.wikimedia.org/wikipedia/commons/d/d7/Sad-pug.jpg")
            ),
        
        mainPanel(
            imageOutput("dog_image")
            )
        )
))

library(shiny)
library(httr)

shinyServer(function(input, output) {

    output$dog_image <- renderImage({

        # get the image
        input$image_url

        # A temp file to save the output.
        # This file will be removed later by renderImage
        outfile <- tempfile(fileext='.png')

        # Generate the PNG
        png(outfile, width=400, height=300)
        hist(rnorm(input$obs), main="Generated in renderImage()")
        dev.off()

         # Return a list containing the filename
        list(src = outfile,
             contentType = 'image/png',
             width = 256,
             height = 256,
             alt = "This is an image of a dog.")
    }, deleteFile = TRUE)

})

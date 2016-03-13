library(shiny)
library(httr)

shinyServer(function(input, output) {

    output$dog_image <- renderImage({

        # A temp file to save the output.
        # This file will be removed later by renderImage
        outfile <- tempfile()

        #cat(input$image_url, file=stderr())
        # get the image
        download.file(input$img_url, outfile, mode="wb")

         # Return a list containing the filename
        list(src = outfile,
             width = 256,
             height = 256,
             alt = "This is an image of a dog.")
    }, deleteFile = TRUE)

})

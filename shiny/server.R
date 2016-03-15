library(shiny)
library(httr)
library(RCurl)
library(jsonlite)

shinyServer(function(input, output) {

    values<-reactiveValues(pug_score_message="")

    output$pug_score_message<-renderText({
        values$pug_score_message
    })

    output$dog_image<-renderImage({
        
        values$pug_score_message<-""
        
        # A temp file to save the output.
        # This file will be removed later by renderImage
        outfile<-tempfile()

        # get the image
        download.file(input$img_url, outfile, mode="wb")

        # convert it
        cmd<-paste("convert ", outfile, " -resize 224x224^ -gravity Center -crop 224x224+0+0 +repage ",
                   outfile)
        system(cmd)

        img<-readBin(outfile, "raw", file.info(outfile)[1, "size"])
        img_b64<-as.character(base64Encode(img, mode="character"))

        # flask-api is defined in /etc/hosts by docker-compose
        response<-POST('http://flask-api:5000/models/pugs',
                       body=list(image=img_b64), encode='json')
        pug_score<-as.numeric(fromJSON(content(response, as="text"))$pug_score)
        pug_score_percent_string<-format(100*pug_score, digits=3)

        if(pug_score >= 0.6){
            values$pug_score_message<-paste0('Yep!!  Definitely a pug!! (', pug_score_percent_string, '%)')
        } else if(pug_score <=0.4){
            values$pug_score_message<-paste0('Nope.  Definitely a golden retriever.  Boooo!! (', pug_score_percent_string, '%)')
        } else {
            values$pug_score_message<-paste0('Not really sure. (', pug_score_percent_string, '%)')
        }
        
         # Return a list containing the filename
        list(src = outfile,
             width = 256,
             height = 256,
             alt = "This is an image of a dog.")
    }, deleteFile = TRUE)

})

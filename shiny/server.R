library(shiny)
library(httr)
library(RCurl)
library(jsonlite)

shinyServer(function(input, output) {

    output$dog_image<-renderImage({

        # A temp file to save the output.
        # This file will be removed later by renderImage
        outfile<-tempfile()

        # get the image
        download.file(input$img_url, outfile, mode="wb")

        # convert it
        cmd<-paste("convert ", outfile, " -resize 256x256^ -gravity Center -crop 256x256+0+0 +repage ",
                   outfile)
        system(cmd)

        img<-readBin(outfile, "raw", file.info(outfile)[1, "size"])
        img_b64<-as.character(base64Encode(img, mode="character"))

        # flask-api is defined in /etc/hosts by docker-compose
        response<-POST('http://flask-api:5000/models/pugs',
                       body=list(image=img_b64), encode='json')
        pug_score<-fromJSON(content(response, as="raw"))$pug_score
        cat(pug_score, file=stderr())

        output$pug_score_message<-renderText({
            'Definitely a pug!!'
        });
        
         # Return a list containing the filename
        list(src = outfile,
             width = 256,
             height = 256,
             alt = "This is an image of a dog.")
    }, deleteFile = TRUE)

})

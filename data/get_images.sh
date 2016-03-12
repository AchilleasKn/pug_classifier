#!/bin/bash

# USAGE bash get_images.sh FILE_WITH_URLS DOWNLOADED_IMAGES_DIR
url_file=$1
downloaded_images_dir=$2

for line in $(cat $url_file)
do 
    sleep 1
    echo "Getting $line..."
    wget --quiet --tries=5 $line -O $downloaded_images_dir/`basename $line`
done

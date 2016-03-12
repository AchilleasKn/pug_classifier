#!/bin/bash

# USAGE bash get_images.sh IMAGES_DIR CROPPED_IMAGES_DIR
images_dir=$1
cropped_images_dir=$2

for file in $images_dir/*
do 
    echo "Cropping $file..."
    convert $file -resize 256x256^ -gravity Center -crop 256x256+0+0 +repage $cropped_images_dir/`basename $file`
done

# one of the services returns a "photo no longer available" thumbnail, so get rid
# of those
echo "Deleting empty images..."
for file in $(ls -lh $cropped_images_dir | grep "2.7K" | awk '{print $9}')
do
    rm -f $cropped_images_dir/$file
done

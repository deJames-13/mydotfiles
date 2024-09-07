#!/bin/bash


blur_file="$HOME/.config/ml4w/settings/blur.sh"
blur="50x30"
blur=$(cat $blur_file)

# defaults
image_name="default-blurred"
current_path=$(pwd)
image_path="$current_path/$1"
output_path="$current_path"


# getops
while getopts "n:i:o:" opt; do
    case ${opt} in
        n ) image_name=$OPTARG ;;
        i ) image_path=$OPTARG ;;
        o ) output_path=$OPTARG ;;
    esac
done


# Check if the image file exists
if [ ! -f $image_path ]; then
    echo "Image file not found."
    exit 1
fi



image_filename=$(basename $image_path)
blurred_image="$output_path/$image_name"

echo ":: Generate new cached image blur-$blur-$image_filename with blur $blur"
# Generate blurred image
if ! magick $image_path -resize 75% $blurred_image; then
    echo "Error resizing image."
    exit 1
fi
echo ":: Resized to 75%"

if [ ! "$blur" == "0x0" ]; then
    if ! magick $blurred_image -blur $blur $blurred_image; then
        echo "Error applying blur."
        exit 1
    fi
    echo ":: Blurred"
fi
echo ":: Blurred image saved to $blurred_image"
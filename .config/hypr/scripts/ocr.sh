# check if teserract, grim, slurp is installed
if ! command -v tesseract &> /dev/null
then
    exit
fi

if ! command -v grim &> /dev/null
then
    exit
fi

if ! command -v slurp &> /dev/null
then
    exit
fi


# teseeract ocr using grim and slurp
grim -g "$(slurp)" - | tesseract stdin stdout | wl-copy
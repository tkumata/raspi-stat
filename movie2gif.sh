#!/bin/bash
#
# require:
#   ImageMagick, libav-tools
#

if [ $# -eq 1 ]; then
    USR_TMP_DIR="$(mktemp -d)"
    MOVIE_FILE="$1"
    FILE_NAME="${MOVIE_FILE%.*}"

    MOVIE_INFO="$(avconv -i "$MOVIE_FILE" 2>&1)"
    SIZE="$(echo "$MOVIE_INFO" | sed '/Video:/!d' | awk '{if(match($0,/[0-9]+x[0-9]+/)) print substr($0,RSTART,RLENGTH)}')"

    echo "Converting movie to temporary files."
    avconv -i "$MOVIE_FILE" -r 10 -y -f image2 -q:v 1 "$USR_TMP_DIR"/tmp-%03d.jpg > /dev/null 2>&1
    #avconv -i "$MOVIE_FILE" -r 10 -y -f image2 -q:v 1 "$USR_TMP_DIR"/tmp-%03d.png > /dev/null 2>&1

    # '-limit' option is IMPORTANT actually for low memory devices like a Raspberry Pi.
    echo "Converting temporary files to gif."
    convert -limit memory 10m -delay 10 "$USR_TMP_DIR"/tmp-*.jpg -define jpeg:size="$SIZE" -layers optimize -loop 0 tmp.gif
    #convert -limit memory 10m -delay 10 "$USR_TMP_DIR"/tmp-*.png -layers optimize -loop 0 tmp.gif
    echo "Optimizing gif."
    convert -limit memory 10m tmp.gif -fuzz 4% -layers optimize "$FILE_NAME".gif

    # Remove temporary files.
    echo "Remove temporary files."
    rm -rf "$USR_TMP_DIR"
else
    echo "No argument found."
    exit 1
fi

#while true; do
#
#    sleep 3
#done

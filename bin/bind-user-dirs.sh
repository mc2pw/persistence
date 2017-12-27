#!/bin/bash

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "getopt test failed."
    exit 1
fi

OPTIONS=l:
LONGOPTIONS=location:

PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    exit 2
fi
eval set -- "$PARSED"

while true; do
    case "$1" in
        -l|--location)
            location="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

# Handle non-option arguments
if [[ $# -ne 0 ]]; then
    echo "$0: Unrecognized option."
    exit 4
fi

# Load localized user dir names
HOME=/home/amnesia
IFS="="
grep -v '^#' "$HOME/.config/user-dirs.dirs" |
sed "s@\$HOME\|\${HOME}@$HOME@" |
while read -r name value; do
    value=$(sed -e 's/^"//' -e 's/"$//' <<<"$value")
    case "$name" in
        XDG_DOWNLOAD_DIR)
            mount --bind "$location/download" "$value"
            ;;
        XDG_TEMPLATES_DIR)
            mount --bind "$location/templates" "$value"
            ;;
        XDG_DOCUMENTS_DIR)
            mount --bind "$location/documents" "$value"
            ;;
        XDG_MUSIC_DIR)
            mount --bind "$location/music" "$value"
            ;;
        XDG_PICTURES_DIR)
            mount --bind "$location/pictures" "$value"
            ;;
        XDG_VIDEOS_DIR)
            mount --bind "$location/videos" "$value"
            ;;
        *)
            ;;
    esac
done


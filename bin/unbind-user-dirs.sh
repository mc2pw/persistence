#!/bin/bash

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "getopt test failed."
    exit 1
fi

OPTIONS=
LONGOPTIONS=

PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    exit 2
fi
eval set -- "$PARSED"

while true; do
    case "$1" in
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
            umount "$value"
            ;;
        XDG_TEMPLATES_DIR)
            umount "$value"
            ;;
        XDG_DOCUMENTS_DIR)
            umount "$value"
            ;;
        XDG_MUSIC_DIR)
            umount "$value"
            ;;
        XDG_PICTURES_DIR)
            umount "$value"
            ;;
        XDG_VIDEOS_DIR)
            umount "$value"
            ;;
        *)
            ;;
    esac
done


#!/bin/bash

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "getopt test failed."
    exit 1
fi

OPTIONS=
LONGOPTIONS=dry-run

PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    exit 2
fi
eval set -- "$PARSED"

dry_run=
while true; do
    case "$1" in
        --dry-run)
            dry_run="--dry-run"
            shift 1
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


# Inspired by https://www.linux.com/news/back-expert-rsync

TARGET="/media/amnesia/UserData"

rsync --progress -avh --delete $dry_run /live/persistence/TailsData_unlocked "$TARGET"

#!/bin/bash

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "getopt test failed."
    exit 1
fi

OPTIONS=c:
LONGOPTIONS=config:

PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    exit 2
fi
eval set -- "$PARSED"

while true; do
    case "$1" in
        -c|--config)
            config="$2"
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

while IFS= read -r pkg; do
    apt-get --assume-yes install "$pkg"
done < "$config"

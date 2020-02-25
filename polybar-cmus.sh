#!/bin/sh

artist=$(echo -n $(cmus-remote -C status | grep "tag artist " | cut -c 12-))

if [[ $artist = *[!\ ]* ]]; then
        song=$(echo -n $(cmus-remote -C status | grep title | cut -c 11-))
        echo -n "$artist - $song"
else
        echo
fi

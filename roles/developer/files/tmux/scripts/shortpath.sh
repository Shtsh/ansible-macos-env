#!/bin/sh
sed "s/^${HOME//\//\\/}/~/ig" < /dev/stdin |\
awk -F '/' '{
    if (NF > 4) {
        LINE = $1;
        for (i = 2; i <= NF-2; ++i) {
            LINE = LINE "/" substr($i, 1, 1);
        }
        print LINE "/" $(NF-1) "/" $(NF)
    } else {
        print
    }
}'

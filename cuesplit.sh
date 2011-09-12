#!/bin/bash
#
# Split APE/FLAC+CUE music
# by liksys (c) 2010 v 1.0
#
#####

echo ":: Splitting..."
cuebreakpoints "$1" | shnsplit -o flac "$2"

echo ":: Tagging..."
cuetag.sh "$1" split-track*.flac

echo ":: Renaming..."
for track in `ls -1 split-track*.flac`; do
	mv "$track" "`metaflac --show-tag=TRACKNUMBER $track \
		| awk '{print sprintf("%02d",substr($0,1+index($0, "=")))}'` - `metaflac --show-tag=TITLE $track \
		| sed -e 's|/|~|g' \
		| awk '{print substr($0, 1+index($0,"="))}'`.flac"
done

echo ":: Complete!"


#!/bin/bash

BASEURL="http://www.hantek.com/Product/DSO2000"
TARGETDIR="./firmware"
ARCHIVE="Driver.rar"
EXTRACTFW="openhantek-extractfw"

if [ -x "./$EXTRACTFW" ]; then
	EXTRACTFW="./$EXTRACTFW"
fi

if [ $# -ge 1 ]; then
	TARGETDIR="$1"
fi

if [ ! -d "$TARGETDIR" ]; then
	mkdir -p "$TARGETDIR"
fi

for MODEL in "2090" "2150" "2250" "5200" "5200A"; do
	echo "Downloading official drivers for DSO$MODEL..."
	wget -nc -q "$BASEURL/DSO${MODEL}_Driver.zip"

	echo "Extracting useful parts from driver archive..."
	unzip -j "DSO${MODEL}_Driver.zip" "*861.sys" -d "$TARGETDIR"
done

if [ -e "$ARCHIVE" ]; then
	rm "$ARCHIVE"
fi

ORIGINALIFS="$IFS"
IFS="
"
for FILENAME in $(find "$TARGETDIR" -iname "*.sys"); do
	echo ""
	echo "Extracting firmware from $FILENAME..."
	"$EXTRACTFW" "$FILENAME" 2>&1 | grep -v "^BFD:.*IMAGE_SCN_MEM_NOT_PAGED"
	rm "$FILENAME"
done
IFS="$ORIGINALIFS"

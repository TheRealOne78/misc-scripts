#!/bin/bash

mkdir tempdir

for f in ./Music/*; do
	tempURL=$(exiftool "${f}" | grep "URL" | sed -r 's/User Defined URL                : //g')
	echo "$tempURL" | grep "youtu\.be"
	if [[ $? -eq 0 ]]; then
		curl "https://www.youtube.com/watch?v=$(basename "${tempURL}")" | grep -E '<link itemprop="name" content="(([a-zA-Z0-9\\\!\@\#\$\%\^\&\*\(\)\_\-\+\=]{1,100}){1,12}) - Topic">'
	fi
	if [[ $? -eq 0 ]]; then
		cd tempdir
		yt-dlp $tempURL
		cd ..
	fi
done

cd tempdir

for f in *; do
	ffmpeg -i "${f}" -frames:v 1 "$(echo ${f} | sed 's/\.webm/\.jpg/g')"
	rm "${f}"
done

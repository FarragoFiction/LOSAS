#!/bin/bash
for f in *.mp3
do
  tempfile="${f##*/}"

  ## display filename
  fileName="${f%.*}"
  echo "Processing $f file...I think it should be ${fileName}.ogg"

  # take action on each file. $f store current file name
  ffmpeg -i $f -acodec libvorbis ${fileName}.ogg


done

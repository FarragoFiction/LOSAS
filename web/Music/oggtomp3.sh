#!/bin/bash
for f in *.ogg
do
  tempfile="${f##*/}"

  ## display filename
  fileName="${f%.*}"
  echo "Processing $f file...I think it should be ${fileName}.m4a"

  # take action on each file. $f store current file name
  ffmpeg -i $f ${fileName}.mp3


done

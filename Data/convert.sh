#!/bin/sh
folder=$1
imgsize=$2
for f in $(find $folder -name '*.jpg')
do
  echo converting $f
  convert $f -resize $imgsize'x'$imgsize\! $f
done

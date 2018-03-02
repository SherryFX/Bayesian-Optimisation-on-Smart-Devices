#!/bin/bash

# Containing trainingSet, testSet, etc
path=$1
echo $path
output=$2
limit=$3
prefix=$4
for dir in $path/*/
do
	dir=${dir%*/}
	echo $dir
	label=$(echo $dir | rev | cut -d "/" -f1 | rev)
	echo $label
	if (("$label" >= "$limit"))
	then
	    echo skipping $label 
		continue
	fi
	cd $path/$label
	echo $( pwd )
	for img in *
	do
		echo $prefix''$label'/'$img' '$label >> ../../../temp
	done 
	cd ../../..
	echo $( pwd )
done

echo "# format=deepcl-jpeg-list-v1 planes=1 width=28 height=28" > $output

shuf temp >> $output

rm temp
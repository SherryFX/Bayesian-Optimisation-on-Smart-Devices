#!/bin/bash

# Containing trainingSet, testSet, etc
mnistpath=$1



for dir in ./testSet/*
do
	label=$(echo $dir | rev | cut -d "/" -f1 | rev)
	cd ./testSet/$label
	for img in *
	do
		echo $mnistpath'/testSet/'$label'/'$img' '$label >> ../../temp.txt
	done
	cd ../..
done


count=$(wc -l < temp.txt)
count="${count#"${count%%[![:space:]]*}"}"
count="${count%"${count##*[![:space:]]}"}"
echo "# format=deepcl-jpeg-list-v1 N=${count} planes=3 width=28 height=28" > manifestTEST.txt
cat temp.txt >> manifestTEST.txt

rm temp.txt

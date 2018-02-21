#!/bin/bash

# Containing trainingSet, testSet, etc
mnistpath=$1



for dir in ./trainingSetPred/*
do
	label=$(echo $dir | rev | cut -d "/" -f1 | rev)
	cd ./trainingSetPred/$label
	for img in *
	do
		echo $mnistpath'/trainingSetPred/'$label'/'$img' '$label >> ../../temp.txt
	done
	cd ../..

done


count=$(wc -l < temp.txt)
count="${count#"${count%%[![:space:]]*}"}"
count="${count%"${count##*[![:space:]]}"}"
echo "# format=deepcl-jpeg-list-v1 N=${count} planes=3 width=28 height=28" > manifestPRED.txt
cat temp.txt >> manifestPRED.txt

rm temp.txt

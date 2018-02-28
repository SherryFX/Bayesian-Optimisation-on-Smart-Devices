#!/bin/bash
for i in {1..10}
do
	echo train_data_batch_$i 'started' 
	python3 imagenet2jpg.py --data "./ImageNet32x32/train_data_batch_"$i --save_dir "./ImageNet32x32/imgs" --size 32 --limit 100
	echo train_data_batch_$i 'done'
done
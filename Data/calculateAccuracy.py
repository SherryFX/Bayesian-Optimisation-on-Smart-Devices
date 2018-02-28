import os
import argparse
import re

def getN(formatLine):
	ind = formatLine.find("N=")
	formatLine=formatLine[ind:]
	N = formatLine.split(' ')[0].split('=')[1]
	print(N)
	return int(N)

def main(res):
	N = 0
	acc = 0
	with open(res) as fp:  
		for cnt, line in enumerate(fp):
			if cnt == 0:
				N = getN(line)
			else:
				strsplit=re.split('\s+', line)
				first = int(strsplit[1])
				second = int(strsplit[2])
				if (first == second):
					acc = acc+1

	print(acc)
	print (acc / N)

if __name__ == '__main__':
	parser = argparse.ArgumentParser(description='calculate accuracy')
	parser.add_argument('--data', type=str, default=None)

	args = parser.parse_args()

	main(args.data)
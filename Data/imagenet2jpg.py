import pickle
import os
import argparse
import numpy as np
from PIL import Image

def unpickle(file):
    with open(file, 'rb') as fo:
        dict = pickle.load(fo)
    return dict

def save_image(fname, img_flat, size):
    ss = size*size
    img_R = img_flat[0:ss].reshape((size, size))
    img_G = img_flat[ss:2*ss].reshape((size, size))
    img_B = img_flat[2*ss:3*ss].reshape((size, size))
    img = np.dstack((img_R, img_G, img_B))
    i = Image.fromarray(img, "RGB")
    i.save(fname)

def main(data, save_dir, size, limit):
    print(data)
    print(save_dir)
    dict=unpickle(data)
    print(len(dict['data']))

    dataname=data.split('/')[-1]
    for i in range(len(dict['labels'])):
        label = dict['labels'][i]
        if (label > limit):
            continue
        img_flat = dict['data'][i]
        pathname=save_dir+'/'+str(label)
        if not os.path.exists(pathname):
            os.makedirs(pathname) 
        filename=dataname + "_" + str(i)

        save_image(pathname+'/'+filename+'.jpg', img_flat, size)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='imagenet converter')
    parser.add_argument('--data', type=str, default=None)
    parser.add_argument('--save_dir', type=str, default=None)
    parser.add_argument('--size', type=int, default=8)
    parser.add_argument('--limit', type=int, default=1000)

    args = parser.parse_args()

    main(args.data, args.save_dir, args.size, args.limit)
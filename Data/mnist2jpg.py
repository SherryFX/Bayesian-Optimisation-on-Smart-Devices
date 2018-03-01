from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import gzip
import os
import argparse
from scipy.misc import imsave
import numpy as np
import csv

IMAGE_SIZE = 28
NUM_CHANNELS = 1
PIXEL_DEPTH = 255
NUM_LABELS = 10

def extract_data(filename):
    """Extract the images into a 4D tensor [image index, y, x, channels].
    Values are rescaled from [0, 255] down to [-0.5, 0.5].
    """
    print('Extracting', filename)
    with open(filename, "rb") as bytestream:
        bytestream.read(4)      # magic number
        buf = bytestream.read(4)
        num_images = int.from_bytes(buf, byteorder='big')
        print(num_images)
        bytestream.read(8)      # nrow x ncol

        dt=np.dtype(np.uint8)
        dt=dt.newbyteorder('>')
        buf = bytestream.read(IMAGE_SIZE * IMAGE_SIZE * num_images)
        data = np.frombuffer(buf, dtype=dt)
        # data = (data - (PIXEL_DEPTH / 2.0)) / PIXEL_DEPTH
        data = data.reshape(num_images,IMAGE_SIZE, IMAGE_SIZE,1)
        data = data.transpose((0,2,1,3))
        return data


def extract_labels(filename):
    """Extract the labels into a vector of int64 label IDs."""
    print('Extracting', filename)
    with open(filename, "rb") as bytestream:
        bytestream.read(4)      # magic number
        buf = bytestream.read(4)
        num_images = int.from_bytes(buf, byteorder='big')
        print(num_images)
        buf = bytestream.read(1 * num_images)
        labels = np.frombuffer(buf, dtype=np.uint8).astype(np.int64)
    return labels

def main(images, labels, out):
    # Extract it into np arrays.
    data = extract_data(images)
    labels = extract_labels(labels)

    if not os.path.isdir(out):
        os.makedirs(out)
    for i in range(len(data)):
        labelled_dir = out + "/" + str(labels[i])
        if not os.path.isdir(labelled_dir):
            os.makedirs(labelled_dir)
        imsave(labelled_dir + "/" + str(i) + ".jpg", data[i][:, :,0])

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='mnist to jpg')
    parser.add_argument('-images', type=str, default=None)
    parser.add_argument('-labels', type=str, default=None)
    parser.add_argument('-out', type=str, default=None)

    args = parser.parse_args()

    main(args.images, args.labels, args.out)
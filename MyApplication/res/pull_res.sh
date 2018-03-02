#!/bin/bash

adb pull /storage/emulated/0/Documents/MyApplication
mv ./MyApplication/* ./
rm -rf MyApplication

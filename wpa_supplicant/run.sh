#!/bin/bash

sudo docker run \
-v $CROSS_COMPILER_PATH:/cross_compiler \
-v $(pwd):/mnt \
-e CROSS_COMPILER_PREFIX=$CROSS_COMPILER_PREFIX \
-e CROSS_COMPILER_PATH=/cross_compiler/$CROSS_COMPILER_BINARY \
-e http_proxy=$http_proxy \
-e https_proxy=$http_proxy \
--rm \
-it \
ubuntu:22.04 /mnt/download_compile_wpa_supplicant.sh
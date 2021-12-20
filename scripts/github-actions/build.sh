#!/usr/bin/env bash

set -e

sudo apt-get update -yy
sudo apt-get install -yy \
  wget python build-essential libxml2 \
  libtool autoconf rapidjson-dev cmake

# setup emsdk
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
git pull
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
cd ..

# setup hext-emscripten
make
make test


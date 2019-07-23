#!/usr/bin/env bash

set -e
set -x

sudo apt-get update -yy
sudo apt-get install -yy \
  wget git libdigest-sha-perl python2.7 python build-essential libxml2 \
  libtool autoconf rapidjson-dev cmake

# setup emsdk
cd ~
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
git pull
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh

# setup hext-emscripten
cd ~
git clone https://github.com/thomastrapp/hext-emscripten.git
cd hext-emscripten
make
make test


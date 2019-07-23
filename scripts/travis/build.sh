#!/usr/bin/env bash

set -e
set -x

REPOS_DIR=$(readlink -f .)

sudo apt-get update -yy
sudo apt-get install -yy \
  wget git python2.7 python build-essential libxml2 \
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
cd "$REPOS_DIR"
make
make test
readlink -f hext-emscripten.*


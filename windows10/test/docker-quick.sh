#!/bin/bash
dir=$(mktemp -d)
cp -r ../. $dir
pushd . && cd $dir
packages=$(tr "\n" " " < packages)
export packages
envsubst '$packages' < test/Dockerfile-quick.template > test/Dockerfile-quick
docker build -t dot_files-quick --file test/Dockerfile-quick .
docker run -ti dot_files-quick 
popd
#!/bin/bash
dir=$(mktemp -d)
cp -r ../. $dir
pushd . && cd $dir
packages=$(tr "\n" " " < packages)
export packages
envsubst '$packages' < test/Dockerfile-quick.template > test/Dockerfile-quick
docker build -t automations-quick --file test/Dockerfile-quick .
docker run -ti automations-quick 
popd
#!/usr/bin/env/bash

docker image pull ryanwoodsmall/crosware
if $(uname -m | grep -q x86_64) ; then
  docker image pull ryanwoodsmall/crosware:zulu
  docker image pull ryanwoodsmall/crosware:amd64
fi
time bash <(curl -kLs https://github.com/ryanwoodsmall/dockerfiles/raw/master/crosware/ccache/build.sh)
# XXX - docker image prune -f

#!/usr/bin/env bash

docker image pull ryanwoodsmall/crosware
if $(uname -m | grep -q x86_64) ; then
  docker image pull ryanwoodsmall/crosware:amd64
  docker image pull ryanwoodsmall/crosware:zulu
elif $(uname -m | grep -q ^arm) ; then
  docker image pull ryanwoodsmall/crosware:arm32v6
elif $(uname -m | grep -q ^aarch64) ; then
  docker image pull ryanwoodsmall/crosware:arm64v8
elif $(uname -m | grep -q 86$) ; then
  docker image pull ryanwoodsmall/crosware:i386
fi
time bash <(curl -kLs https://github.com/ryanwoodsmall/dockerfiles/raw/master/crosware/ccache/build.sh)
# XXX - docker image prune -f

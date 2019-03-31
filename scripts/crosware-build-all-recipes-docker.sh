#!/bin/bash

#
# do a full crosware build using a container with volumes for...
#   - /root/.ccache
#   - /usr/local/crosware/downloads
# this should significantly speed up subsequent full rebuilds
#

#set -eu

i="ryanwoodsmall/crosware"
c="/usr/local/crosware/bin/crosware"
v="-v crosware-downloads:/usr/local/crosware/downloads -v crosware-ccache:/root/.ccache"

# build a ccache-enabled base image
bash <(curl -kLs https://github.com/ryanwoodsmall/dockerfiles/raw/master/crosware/ccache/build.sh)

for r in $(docker run --rm ${i} ${c} list-available) ; do
  echo ${r}
  n="crosware-${r}"
  l="/tmp/${n}.out"
  docker kill ${n} || true
  docker rm -f ${n} || true
  ( time ( docker run --name ${n} ${v} ${i} bash -l ${c} install ${r} ; echo ${?} ) ) 2>&1 | tee ${l}
  docker kill ${n} || true
  docker rm -f ${n} || true
done

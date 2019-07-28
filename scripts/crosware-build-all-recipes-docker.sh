#!/bin/bash

#
# do a full crosware build using a container with volumes for...
#   - /root/.ccache
#   - /usr/local/crosware/downloads
# this should significantly speed up subsequent full rebuilds
# need to save a list of installed at begin and end of run, like
#   - docker run --name ${n} ${v} ${i} bash -l -c "${c} list-installed > /tmp/inst.1 ; ${c} install ${r} ; xval=${?} ; ${c} list-intalled > /tmp/inst.2 ; diff -Naur /tmp/inst.{1,2}; exit ${xval}"
# jesus christ
#

#set -eu

i="ryanwoodsmall/crosware"
c="/usr/local/crosware/bin/crosware"
v="-v crosware-downloads:/usr/local/crosware/downloads -v crosware-ccache:/root/.ccache"
: ${z:=""}

# build a ccache-enabled base image
bash <(curl -kLs https://github.com/ryanwoodsmall/dockerfiles/raw/master/crosware/ccache/build.sh)

# use alpine/musl zulu - only on x86_64
if [ ! -z "${z}" ] ; then
  if [[ ${MACHTYPE} =~ ^x86_64- ]] ; then
    docker build --tag ${i} https://github.com/ryanwoodsmall/dockerfiles/raw/master/crosware/zulu/Dockerfile
  fi
fi

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

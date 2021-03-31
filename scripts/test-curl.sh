#!/usr/bin/env bash

#
# test currently installed curl version for https interop
#

if [ -z "${cwsw}" ] ; then
  echo "is this crosware?" 1>&2
  exit 1
fi

for i in $(realpath ${cwsw}/curl/current/bin/curl-*{ssl,tls}* | sort -u) ; do
  echo ${i}
  ${i} --version
  ${i} -kILs https://www.google.com/
  echo --
  echo
done

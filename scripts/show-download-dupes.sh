#!/usr/bin/env bash

#
# show files with multiple versions under downloads/pkg/...
# XXX - a few packages have multiple files (git, dropbear, manpages, ...)
# 

if [ -z "${cwtop}" ] ; then
  cwtop="$(realpath $(dirname ${BASH_SOURCE[0]})/..)"
fi

cd ${cwtop}/downloads ; for i in */ ; do
  find $i -maxdepth 1 -mindepth 1 -type f \
  | grep -v '/bash..-...' \
  | wc -l \
  | grep -q '^1$' \
    || find $i -type f \
       | egrep -v 'bsd.*/.*\.(c|h|1)$'
done | sort 

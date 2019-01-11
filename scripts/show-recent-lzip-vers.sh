#!/bin/bash

#
# crappy dummy placeholder lzip version dumper
#

set -eu

cw="$(dirname ${BASH_SOURCE[0]})/../bin/crosware"
if [ ! -e "${cw}" ] ; then
  echo 'crosware not found'
  exit 1
fi

${cw} set \
| gawk '/cwfetch.*\/(l(|un)zip|lzlib|zutils)\//{print $2}' \
| while read -r l ; do
  u="$(dirname ${l})"
  curl -kLs "${u}" \
  | grep "$(date '+%Y')" \
  | tr -s ' ' \
  | tr ' ' '\n' \
  | awk -F'"' '/^href=/{print $2}' \
  | egrep -v '(/|\.sig)$' \
  | sed "s#^#${u}/#g"
done

echo

${cw} list-recipe-versions \
| egrep '(l.*zip|lzlib|zutils)'

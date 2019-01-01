#!/bin/bash

#
# show latest vim github release version
#

set -eu

if [ ${#} -ne 1 ] ; then
  vmax="$(curl -kLs "https://github.com/vim/vim/releases" \
  | xmllint --format --html - 2>/dev/null \
  | awk -F'"' '/\/vim\/vim\/releases\/tag\//{print $2}' \
  | head -1 \
  | xargs basename \
  | sed s/^v//g)"
else
  vmax="${1}"
fi
echo "${vmax}"

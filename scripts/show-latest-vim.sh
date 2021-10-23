#!/bin/bash

#
# show latest vim github release version
#

set -eu

prereqs=( 'curl' 'xmllint' )
for prereq in ${prereqs[@]} ; do
  hash "${prereq}" >/dev/null 2>&1 || {
    echo "$(basename ${BASH_SOURCE[0]}): ${prereq} not found"
    exit 1
  }
done

if [ ${#} -ne 1 ] ; then
  vmax="$(curl -kLs "https://github.com/vim/vim/tags" \
  | xmllint --format --html - 2>/dev/null \
  | awk -F'"' '/\/vim\/vim\/releases\/tag\//{print $2}' \
  | head -1 \
  | xargs basename \
  | sed s/^v//g)"
else
  vmax="${1}"
fi
echo "${vmax}"

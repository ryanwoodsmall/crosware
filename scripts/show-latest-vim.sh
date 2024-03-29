#!/bin/bash

#
# show latest vim github release version
#
# XXX - use xmllint? uses xpath, does this work for html?
#   curl ... | xmllint --xpath '/*[local-name()="blah"]/*[local-name()="diblah"]/text()' -
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
  | awk -F'"' '/\/vim\/vim\/archive\/refs\/tags\//{print $4}' \
  | grep -E 'v[0-9]+\.[0-9]+\.[0-9]{4}\.tar\.gz' \
  | head -1 \
  | xargs basename \
  | sed 's/^v//g;s/\.tar\.gz//g')"
else
  vmax="${1}"
fi
echo "${vmax}"

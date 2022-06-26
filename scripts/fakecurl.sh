#!/usr/bin/env bash
#
# fake curl that uses busybox/gnu wget
# might be enough for cwfetch()?
#
# XXX - _rename_ to cwfetch?
# XXX - other wrappers - curl/wget, wget/curl?
#

echo "this is fake curl" 1>&2

set -eu
set -o pipefail

if ! command -v wget &>/dev/null ; then
  echo "wget not found" 1>&2
  exit 1
fi

: ${wget:="wget"}
: ${wgetopts:="--no-check-certificate"}

declare -a a=()
for i in $(seq 0 $((${#}-1))) ; do
  a[${i}]="${1}"
  shift
done

# args come in from cwfetch as:
#   cwfetch "scheme://url/file.ext" "/full/path/to/save/file.ext"
# figure target item as last input array element, url item as next to last
ti="${#a[@]}"
((ti--))
ui="${#a[@]}"
((ui--))
((ui--))

${wget} ${wgetopts} -O "${a[${ti}]}" "${a[${ui}]}"

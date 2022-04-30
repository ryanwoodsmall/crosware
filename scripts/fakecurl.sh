#!/usr/bin/env bash
#
# fake curl that uses busybox/gnu wget
# might be enough for cwfetch()?
#

echo "this is fake curl" 2>&1

set -eu
set -o pipefail

declare -a a=()
for i in $(seq 0 $((${#}-1))) ; do
  a[${i}]="${1}"
  shift
done

ti="${#a[@]}"
((ti--))
ui="${#a[@]}"
((ui--))
((ui--))

wget -O "${a[${ti}]}" "${a[${ui}]}"

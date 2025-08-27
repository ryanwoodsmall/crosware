#!/bin/bash
#
# enable idle suspend
#
set -eu
set -o pipefail

for p in {,/usr{,/local}}/{,s}bin ; do
  PATH="${p}:${PATH}"
done
export PATH

if [[ ${UID} != 0 ]] ; then
  echo "please run as root" 1>&2
  exit 1
fi

d="/var/lib/power_manager"
for f in {,un}plugged_{dim,off,suspend}_ms ignore_external_policy disable_idle_suspend ; do
  if [ -e "${d}/${f}" ] ; then
    rm -f "${d}/${f}"
  fi
done

restart powerd

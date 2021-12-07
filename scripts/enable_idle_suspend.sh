#!/usr/bin/env bash
#
# enable idle suspend
#
set -eu
set -o pipefail

if [[ ${UID} != 0 ]] ; then
  echo "please run as root" 1>&2
  exit 1
fi

f="/var/lib/power_manager/disable_idle_suspend"
if [ -e "${f}" ] ; then
  rm -f "${f}"
fi

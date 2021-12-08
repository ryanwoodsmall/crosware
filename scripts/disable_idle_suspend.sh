#!/usr/bin/env bash
#
# disable idle suspend
#
set -eu
set -o pipefail

if [[ ${UID} != 0 ]] ; then
  echo "please run as root" 1>&2
  exit 1
fi

f="/var/lib/power_manager/disable_idle_suspend"
d="$(dirname ${f})"
test -e "${d}" || mkdir -p "${d}"
touch "${f}"

u="power"
g="power"
chown ${u}:${g} "${f}"

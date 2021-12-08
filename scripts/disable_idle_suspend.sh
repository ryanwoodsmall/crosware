#!/usr/bin/env bash
#
# disable idle suspend
#
# XXX - this doesn't work all the time but should
#   https://chromium.googlesource.com/chromiumos/platform2/+/master/power_manager/docs/faq.md
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
echo 1 > "${f}"

echo 1 >/var/lib/power_manager/ignore_external_policy
for i in {,un}plugged_{dim,off,suspend}_ms ; do
  echo 0 >/var/lib/power_manager/${i}
done

u="power"
g="power"
find "${d}/" ! -type d -exec chown ${u}:${g} {} +

restart powerd

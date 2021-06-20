#!/usr/bin/env bash
#
# start busybox httpd at the crosware root on port 18080 by default
#

: ${cwtop:="/usr/local/crosware"}
: ${httpport:="18080"}
: ${httproot:="${cwtop}"}

function failexit() {
  echo "${BASH_SOURCE[0]}: ${@}" 1>&2
  exit 1
}

test -e "${cwtop}/etc/profile" || failexit "no profile to source"
. "${cwtop}/etc/profile"

if ! $(which busybox >/dev/null 2>&1) ; then
  failexit "no busybox"
fi

busybox httpd -f -vv -h "${httproot}" -p "${httpport}"

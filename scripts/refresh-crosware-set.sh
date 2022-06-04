#!/usr/bin/env bash
#
# update ${cwtop}/tmp/crosware.set.out without having to run cloc
#
set -eu
set -o pipefail

sn="$(basename ${BASH_SOURCE[0]})"

: ${cwtop:="/usr/local/crosware"}
: ${cwsout:="${cwtop}/tmp/crosware.set.out"}
: ${cwsold:="${cwsout}.old"}

command -v crosware &>/dev/null || { echo "${sn}: no crosware" 1>&2 ; exit 1 ; }
test -e "${cwsout}" && { echo "${sn}: saving ${cwsout} to ${cwsold}" ; cat "${cwsout}" > "${cwsold}" ; } || touch "${cwsold}"
echo "${sn}: saving new ${cwsout}"
crosware set > "${cwsout}"

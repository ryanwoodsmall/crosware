#!/usr/bin/env bash
#
# update crosware from master.zip
#

set -eu

function failexit() {
  echo "${BASH_SOURCE[0]}: ${@}" 1>&2
  exit 1
}

reqs=( 'unzip' 'curl' 'tar' )
for req in ${reqs[@]} ; do
  which ${req} >/dev/null 2>&1 || failexit "req ${req} not found"
done

: ${version:="master"}
: ${zipfile:="${version}.zip"}
: ${zipurl:="https://github.com/ryanwoodsmall/crosware/archive/${zipfile}"}
: ${extdir:="crosware-${version}"}
: ${cwtop:="/usr/local/crosware"}
: ${cwtmp:="${cwtop}/tmp"}

if [ ! -e "${cwtmp}" ] ; then
  mkdir -p "${cwtmp}" || failexit "could not ${cwtmp} or it does not exist"
fi

pushd "${cwtmp}"
rm -rf "${extdir}"
rm -f "${zipfile}"
curl -kLo "${zipfile}" "${zipurl}" 
unzip "${zipfile}"
( cd "${extdir}" ; tar -cf - . | ( cd "${cwtop}" ; tar -xvf - ) )
popd

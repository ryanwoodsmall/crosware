#!/usr/bin/env bash
#
# update crosware from a tarball
#

set -eu
set -o pipefail

function failexit() {
  echo "${BASH_SOURCE[0]}: ${@}" 1>&2
  exit 1
}

reqs=( 'tar' )
for req in ${reqs[@]} ; do
  which ${req} >/dev/null 2>&1 || failexit "req ${req} not found"
done

: ${version:="master"}
: ${tarfile:="${version}.tgz"}
: ${vendor:="ryanwoodsmall"}
: ${project:="crosware"}
: ${tarurl:="https://github.com/${vendor}/${project}/tarball/${version}"}
: ${cwtop:="/usr/local/crosware"}
: ${cwtmp:="${cwtop}/tmp"}

if [ ! -e "${cwtmp}" ] ; then
  mkdir -p "${cwtmp}" || failexit "could not ${cwtmp} or it does not exist"
fi

pushd "${cwtmp}"
rm -f "${tarfile}"
curl -fkLo "${tarfile}" "${tarurl}" || wget -O "${tarfile}" "${tarurl}"
extdir="$(tar -ztvf ${tarfile} | grep '/$' | awk '{print $NF}' | sort | grep ^${vendor}-${project}- | grep -v '/.*/' | head -1 || true)"
if [[ ! ${extdir} =~ ^${vendor}-${project}- ]] ; then
  failexit "extraction directory '${extdir}' doesn't look right"
fi
rm -rf "${extdir}"
tar -zxf "${tarfile}"
( cd "${extdir}" ; tar -cf - . | ( cd "${cwtop}" ; tar -xvf - ) )
rm -f "${tarfile}"
rm -rf "${extdir}"
popd

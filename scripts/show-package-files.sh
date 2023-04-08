#!/usr/bin/env bash
#
# show all the files that are part of a package with sizes and types
#
set -euo pipefail
sn="$(basename -- ${BASH_SOURCE[0]})"

function scriptecho() {
  echo "${sn}: ${@}" 1>&2
}

function failexit() {
  scriptecho "${@}" 1>&2
  exit 1
}

function findfiles() {
  local d="${cwsw}/${1}/current/"
  test -e "${d}" || { scriptecho "${1}: not installed" ; return ; }
  # XXX - probably needs to be tightened up with find -print0/xargs -0 !!!
  find "${d}" ! -type d | xargs realpath | sort -u | xargs filesizetype.sh
}

if [[ ${#} == 0 ]] ; then
  failexit "pass at least one package name"
fi

td="$(cd $(dirname -- ${BASH_SOURCE[0]}) && pwd)"
: ${cwtop:="$(realpath ${td}/..)"}
test -e ${cwtop}/bin/crosware && export cw=${cwtop}/bin/crosware
: ${cw:="${cwtop}/bin/crosware"}
: ${cwetc:="${cwtop}/etc"}
: ${cwetcprof:="${cwetc}/profile"}
: ${cwsw:="${cwtop}/software"}
export cwtop cw cwetc cwetcprof cwsw

for p in filesizetype.sh coltotal ; do
  command -v ${p} &>/dev/null || { scriptecho "installing required programs" ; ${cw} reinstall shellish 1>&2 ; source ${cwetcprof} ; }
done
command -v filesizetype.sh &>/dev/null && command -v coltotal &>/dev/null || failexit "required program not found"
unset p

if [[ ${#} == 1 ]] ; then
  test -e "${cwsw}/${1}/current/" || failexit "${1}: not installed"
  findfiles "${1}"
else
  for p in ${@} ; do
    findfiles "${p}" | sed "s,^,${p}: ,g"
  done
fi

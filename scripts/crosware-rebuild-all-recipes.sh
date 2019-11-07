#!/usr/bin/env bash

#
# uninstall/rebuild/reinstall everything
#

function failexit() {
  echo "${1}"
  exit 1
}

td="$(cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)"
test -e "${td}/bin/crosware" || {
  failexit "could not find crosware top directory"
}
cw="${td}/bin/crosware"

${cw} list-installed | cut -f1 -d: | xargs ${cw} uninstall

{ echo statictoolchain make ccache ; ${cw} list-recipes ; } | while read -r r ; do
  o="/tmp/${r}.out"
  echo ${r} 1>&2
  ${cw} check-installed ${r} || ( time ( ${cw} install ${r} ; echo $? ) ) 2>&1 | tee ${o}
done >/tmp/crosware_rebuild.out

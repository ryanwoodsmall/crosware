#!/usr/bin/env bash

#
# uninstall/rebuild/reinstall everything
#

st="$(date '+%Y%m%d%H%M%S')"
out="/tmp/crosware_rebuild.out"

function failexit() {
  echo "${1}" 1>&2
  exit 1
}

td="$(cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)"
test -e "${td}/bin/crosware" || failexit "could not find crosware top directory/executable"
cw="${td}/bin/crosware"

echo "start: ${st}" | tee ${out}

${cw} list-installed | cut -f1 -d: | xargs ${cw} uninstall

for r in statictoolchain ccache $(${cw} list-recipes) ; do
  echo ${r} 1>&2
  ${cw} check-installed ${r} || ( time ( ${cw} install ${r} ; echo $? ) ) 2>&1 | tee /tmp/${r}.out
done | tee -a ${out}

et="$(date '+%Y%m%d%H%M%S')"
echo "end: ${et}" | tee -a ${out}

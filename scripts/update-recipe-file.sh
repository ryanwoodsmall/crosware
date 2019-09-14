#!/usr/bin/env bash

#
# update a recipe.sh file given:
#  - recipe name
#  - recipe version
#  - recipe file sha256sum
#
# XXX:
#  - generalize as a verb?
#  - "crosware update-recipe-file recipe 1.2.3 abcdef0123456789...."
#  - add "crosware upgrade recipe"?
#  - add git commit?
#

set -eu

function failexit() {
  echo "${1}"
  exit 1
}

if [ "${#}" -ne 3 ] ; then
  failexit "$(basename ${BASH_SOURCE[0]}) recipe version.dot.number sha256"
fi

rn="${1}"
rv="${2}"
rs="${3}"

td="$(cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)"
test -e "${td}/bin/crosware" || {
  failexit "could not find crosware top directory"
}
rd="${td}/recipes"
echo "top directory is ${td}"
echo "recipe directory is ${rd}"

if ! $(find ${rd}/*/*.sh -name ${rn}.sh | wc -l | grep -q '^1$') ; then
  failexit "ambiguous recipe name ${rn}; no such recipe ${rn} or multiple ${rn}.sh files found"
fi
rf="$(find ${rd}/*/*.sh -name ${rn}.sh)"
echo "recipe file is ${rf}"

for fe in rver rsha256 ; do
  if ! $(grep -q "^${fe}=" "${rf}") ; then
    failexit "no ${fe} line in ${rf}"
  fi
  cv="$(grep "^${fe}=" "${rf}" | cut -f2 -d= | tr -d '"')"
  echo "current value of ${fe} in ${rf} is ${cv}"
done

echo "setting value of 'rver' in ${rf} to ${rv}"
sed -i "s#^rver=.*#rver=\"${rv}\"#" "${rf}"
echo "setting value of 'rsha256' in ${rf} to ${rs}"
sed -i "s#^rsha256=.*#rsha256=\"${rs}\"#" "${rf}"

echo "git diff:"
echo
git diff
echo

echo "git commit command:"
echo
echo "  git commit -a -m '${rn}: update to ${rv}'"
echo

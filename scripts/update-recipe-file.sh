#!/usr/bin/env bash

#
# update a recipe.sh file given:
#  - recipe name
#  - recipe version
#  - (optionally) recipe file sha256sum
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

if [ "${#}" -lt 2 ] ; then
  failexit "$(basename ${BASH_SOURCE[0]}) recipe version.dot.number [sha256]"
fi

rn="${1}"
rv="${2}"
rs=""
if [ "${#}" -ge 3 ] ; then
  rs="${3}"
fi

td="$(cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)"
cw="${td}/bin/crosware"
test -e "${cw}" || {
  failexit "could not find crosware top directory"
}
if [ "${rs}x" == "x" ] ; then
  echo "no sha256sum passed, attempting to figure one out"
  ov="$(${cw} run-func cwver_${rn})"
  ru="$(${cw} run-func cwurl_${rn} | sed "s/${ov}/${rv}/g")"
  rs="$(curl -kLs "${ru}" | sha256sum | awk '{print $1}')"
fi
if ! $(echo -n "${rs}" | wc -c | grep -q '^64$') ; then
  echo "${rs} doesn't look right..."
  exit 1
fi

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

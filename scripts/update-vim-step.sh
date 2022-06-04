#!/usr/bin/env bash

#
# updates vim tag by tag and commit
# this is cheating
#
# XXX:
# - use scripts/update-recipe-file.sh?
#

set -eu

if ! command -v git &>/dev/null ; then
  echo "this script requires git"
  exit 1
fi

uvr="$(dirname $(realpath ${BASH_SOURCE[0]}))/update-vim-recipe.sh"
slv="$(dirname $(realpath ${BASH_SOURCE[0]}))/show-latest-vim.sh"
if [ ! -e "${uvr}" -o ! -e "${slv}" ] ; then
  echo "$(basename ${uvr}) or $(basename ${slv}) not found"
  exit 1
fi

z='4'
function sz() {
  local v="${1}"
  while $(echo "${v}" | grep -q '^0') ; do
    v="${v#0}"
  done
  if [ "${v}x" == "x" ] ; then
    v=1
  fi
  echo "${v}"
}
function pz() {
  local v="${1}"
  while $(test $(echo -n "${v}" | wc -c) -lt "${z}") ; do
    v="0${v}"
  done
  echo "${v}"
}

cwtop="/usr/local/crosware"
vrp="${cwtop}/recipes/vim/vim.sh"
vver="$(awk -F'"' '/^rver=/{print $2}' ${vrp})"
vmaj="${vver%%.*}"
vmin="${vver#*.}"
vmin="${vmin%%.*}"
vpat="${vver##*.}"
echo "cur ver is ${vver}"

if [ ${#} -ne 1 ] ; then
  vmax="$(bash ${slv})"
else
  vmax="${1}"
fi
vmaxpat="${vmax##*.}"
echo "max ver is ${vmax}"

if [ $(sz ${vpat}) -lt $(sz ${vmaxpat}) ] ; then
  vpat="$(sz ${vpat})"
  ((vpat++))
  for p in $(seq "${vpat}" $(sz "${vmaxpat}")) ; do
    v="${vmaj}.${vmin}.$(pz ${p})"
    "${uvr}" "${v}"
    git add "${vrp}"
    git commit -m "vim: update to ${v}"
  done
fi

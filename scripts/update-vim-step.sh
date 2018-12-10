#!/usr/bin/env bash

#
# updates vim tag by tag and commit
# this is cheating
#

set -eu

uvr="$(dirname $(realpath ${BASH_SOURCE[0]}))/update-vim-recipe.sh"
test -e "${uvr}" || {
  echo "$(basename ${uvr}) not found"
  exit 1
}

z='4'
function sz() {
  local v="${1}"
  while $(echo "${v}" | grep -q '^0') ; do
    v="${v#0}"
  done
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
vver="$(awk -F'"' '/^rver=/{print $2}' ${cwtop}/recipes/vim/vim.sh)"
vmaj="${vver%%.*}"
vmin="${vver#*.}"
vmin="${vmin%%.*}"
vpat="${vver##*.}"
echo "cur ver is ${vver}"

if [ ${#} -ne 1 ] ; then
  vmax="$(curl -kLs "https://github.com/vim/vim/releases" \
  | xmllint --format --html - 2>/dev/null \
  | awk -F'"' '/\/vim\/vim\/releases\/tag\//{print $2}' \
  | head -1 \
  | xargs basename \
  | sed s/^v//g)"
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
    git commit -a -m "vim: update to ${v}"
  done
fi

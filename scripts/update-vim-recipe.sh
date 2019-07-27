#!/usr/bin/env bash

#
# given a vim verison matching #.#.####...
# -*or*-
# no arguments...
# - figure out either given or latest default version
# - make sure it's valid
# - get the sha256sum
# - update the vim recipe
# - build/upgrade vim
# - show the version
# - show git diff
# - dump the git commit command
#
# TODO:
# - make this generic?
# - recipe and version number?
#
# XXX:
# - use scripts/update-recipe-file.sh???
#

set -eu

td="$(cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)"

cw="${td}/bin/crosware"

vrf="${td}/recipes/vim/vim.sh"

vbu="https://github.com/vim/vim"

slv="$(dirname $(realpath ${BASH_SOURCE[0]}))/show-latest-vim.sh"
if [ ! -e "${slv}" ] ; then
  echo "$(basename ${slv}) not found"
  exit 1
fi

if [ ${#} -ne 1 ] ; then
  vvn="$(bash ${slv})"
else
  vvn="${1}"
fi

if [ ! -e "${vrf}" ] ; then
  echo "${vrf} not found; cd /usr/local/crosware ???"
  exit 1
fi

vfu="${vbu}/archive/v${vvn}.tar.gz"

if ! $(curl -fkILs "${vfu}" >/dev/null 2>&1) ; then
  echo "HEAD against ${vfu} failed"
  exit 1
fi

vss="$(curl -fkLs ${vfu} | sha256sum | awk '{print $1}')"

sed -i '/^rver=/s/^rver=.*/rver="'"${vvn}"'"/g' "${vrf}"
sed -i '/^rsha256=/s/^rsha256=.*/rsha256="'"${vss}"'"/g' "${vrf}"

if $(git diff "${vrf}" | wc -l | grep -q '^0$') ; then
  echo "no change detected in ${vrf}"
  exit 1
fi

git diff "${vrf}"
echo
"${cw}" list-upgradable
"${cw}" upgrade vim
echo
"${td}/software/vim/current/bin/vim" --version | egrep '(^VIM|patches:)'
echo
git diff "${vrf}"
echo
echo "git commit -a -m 'vim: update to ${vvn}'"
echo

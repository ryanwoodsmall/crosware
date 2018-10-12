#!/usr/bin/env bash

#
# given a vim verison matching #.#.####:
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

set -eu

td="$(cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)"

cw="${td}/bin/crosware"

vrf="${td}/recipes/vim/vim.sh"

if [ ${#} -ne 1 ] ; then
  echo "please provide a single vim version number"
  exit 1
fi

if [ ! -e "${vrf}" ] ; then
  echo "${vrf} not found; cd /usr/local/crosware ???"
  exit 1
fi

vfu="https://github.com/vim/vim/archive/v${1}.tar.gz"

if ! $(curl -fkILs "${vfu}" >/dev/null 2>&1) ; then
  echo "HEAD against ${vfu} failed"
  exit 1
fi

vss="$(curl -fkLs ${vfu} | sha256sum | awk '{print $1}')"

sed -i '/^rver=/s/^rver=.*/rver="'"${1}"'"/g' "${vrf}"
sed -i '/^rsha256=/s/^rsha256=.*/rsha256="'"${vss}"'"/g' "${vrf}"

git diff "${vrf}"
echo
"${cw}" list-upgradable
"${cw}" upgrade vim
echo
"${td}/software/vim/current/bin/vim" --version | egrep '(^VIM|patches:)'
echo
git diff "${vrf}"
echo
echo "git commit -a -m 'vim: update to ${1}'"
echo

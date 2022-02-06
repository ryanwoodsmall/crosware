#!/bin/sh
#
# install some simple dotfiles for convenience/comfort
#

set -eu

if ! command -v curl >/dev/null 2>&1 ; then
  echo 'curl not found' 1>&2
  exit 1
fi

baseurl="https://raw.githubusercontent.com/ryanwoodsmall/dotfiles/master"

for f in bim3rc bimrc elvisrc exrc vilerc vimrc ; do
  durl="${baseurl}/dot_${f}"
  df="${HOME}/.${f}"
  if [ -e "${df}" ] ; then
    echo "${df} already exists, skipping"
    continue
  else
    echo "installing ${df} from ${durl}"
    curl -fkLs "${durl}" > "${df}"
  fi
done

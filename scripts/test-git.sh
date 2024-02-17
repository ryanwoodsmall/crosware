#!/usr/bin/env bash
#
# test currently installed {j,}git versions for https, ssh git interop
#

if [ -z "${cwtop}" ] ; then
  echo "is this crosware?" 1>&2
  exit 1
fi

td="${cwtop}/tmp"

if [ ! -e "${td}" ] ; then
  echo "no ${cwtop}/tmp dir" 1>&2
  exit 1
fi

: ${GIT_SSH_COMMAND=""}
test -z "${GIT_SSH_COMMAND}" && export GIT_SSH_COMMAND=ssh || true

gh="github.com"
bpr="ryanwoodsmall/vimrcs.git"
co="$(basename ${bpr%%.git})"

repos="https://${gh}/${bpr}"

if $(${GIT_SSH_COMMAND} git@${gh} |& grep -qi successfully) ; then
  repos+=" git@${gh}:${bpr}"
fi

pushd "${td}"
for u in ${repos} ; do
  for g in $(realpath ${cwsw}/*/current/bin/{git{,libressl},jgitsh} | sort -u) ; do
    rm -rf "${co}"
    echo "${g} : ${u}"
    "${g}" clone "${u}"
    echo ${?}
    echo
    rm -rf "${co}"
  done
done
popd

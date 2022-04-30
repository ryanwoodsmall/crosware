#!/usr/bin/env bash
#
# install some static binaries to a temp dir
#

set -eu
set -o pipefail

function failexit() {
  echo "${BASH_SOURCE[0]}: ${@}" 1>&2
  exit 1
}

a=''
uname -m | grep -q ^a  && a=armhf   || true
uname -m | grep -q ^aa && a=aarch64 || true
uname -m | grep -q ^i  && a=i686    || true
uname -m | grep -q ^x  && a=x86_64  || true
uname -m | grep -q ^r  && a=riscv64 || true

if [ -z "${a}" ] ; then
  cwfailexit "not sure what arch this is"
fi

: ${version:="master"}
: ${vendor:="ryanwoodsmall"}
: ${project:="static-binaries"}
: ${baseurl:="https://github.com/${vendor}/${project}/raw/${version}"}
: ${cwtop:="/usr/local/crosware"}
: ${cwtmp:="${cwtop}/tmp"}

tempbin="${cwtmp}/static/bin"

if [ ! -e "${tempbin}" ] ; then
  mkdir -p "${tempbin}" || failexit "could not mkdir ${tempbin} or it does not exist"
fi

pushd "${tempbin}"
  # XXX - cwstatictinaries:
  #   bash brssl busybox curl dash jo jq less links make mk mksh neatvi rc rlwrap rsync sbase-box screen socat stunnel tini tmux toybox ubase-box unrar xz
  for p in bash busybox curl dash less make mk mksh neatvi rc rlwrap rsync screen sbase-box tini toybox ubase-box xz ; do
    u="${baseurl}/${a}/${p}"
    t="${tempbin}/${p}"
    curl -fkLo "${t}" "${u}" || wget -O "${t}" "${u}"
    chmod 755 "${t}"
  done
  for a in $(./busybox --list) ; do
    test -e "${a}" || ln -s busybox "${a}"
  done
  for p in toybox sbase-box ubase-box ; do
    for a in $(./${p}) ; do
      test -e "${a}" || ln -s "${p}" "${a}"
    done
  done
popd

echo "binaries installed in ${tempbin}"
echo "run crosware with:"
echo
echo "  env PATH="${tempbin}:\${PATH}" crosware"
echo

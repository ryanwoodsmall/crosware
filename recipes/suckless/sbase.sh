rname="sbase"
rver="4fcb31c6e00bf201836b0b0baf2ce60051f3db51"
rdir="${rname}-${rver}"
rurl="https://git.suckless.org/${rname}"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="make \${CW_GIT_CMD}"
rfile=""
rsha256=""

. "${cwrecipe}/common.sh"
. "${cwrecipe}/suckless/suckless.sh.common"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make ${rname}-box
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make ${rname}-box-install
  popd >/dev/null 2>&1
}
"

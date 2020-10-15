rname="sbase"
rver="cd9f55f5e1c8035840ecf906665b418db47a56c1"
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

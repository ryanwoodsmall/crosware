rname="sbase"
rver="7d60e2cabbe07495ee74f3d5e705f1e3470148eb"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rprof="${cwetcprofd}/zz_${rname}.sh"
rsha256="dadf515a121804c9f789529e9028683b651cd9f0b2ebc040854b996f4221702a"
rreqs="bootstrapmake"

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

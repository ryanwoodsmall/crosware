rname="bash4"
rver="4.4.23"
rdir="${rname%4}-${rver}"
rbdir="${cwbuild}/${rname%4}-${rver%.*}"
rfile="${rname%4}-${rver%.*}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname%4}/${rfile}"
rsha256="d86b3392c1202e8ff5a423b302e6284db7f8f435ea9f39b5b1b20fd3ac36dfcb"
rreqs="make byacc sed netbsdcurses patch configgit"
rpfile="${cwrecipe}/${rname%4}/${rname}.patches"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname%4}/${rname%4}.sh.common"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  # ganked from alpine
  #  https://git.alpinelinux.org/cgit/aports/tree/main/bash/APKBUILD
  make y.tab.c
  make -j${cwmakejobs} builtins/libbuiltins.a
  make -j${cwmakejobs}
  make strip
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  install -m 0755 bash \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/${rname%4}\"
  ln -sf \"${rtdir}/current/bin/${rname%4}\" \"${ridir}/bin/sh\"
  popd >/dev/null 2>&1
}
"

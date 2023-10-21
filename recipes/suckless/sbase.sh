rname="sbase"
rver="53040766d1a09baa7412c73c9a93afac2bfd6acc"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rprof="${cwetcprofd}/zz_${rname}.sh"
rsha256="3016002557c3c43619b542a6af682288bde83a1480729ab0a7b794400a39bb1f"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/suckless/suckless.sh.common"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ( unset CPPFLAGS ; make sbase-box ) || cwfailexit \"${rname}: build failed\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ( unset CPPFLAGS ; make sbase-box-install ) || cwfailexit \"${rname}: install failed\"
  popd >/dev/null 2>&1
}
"

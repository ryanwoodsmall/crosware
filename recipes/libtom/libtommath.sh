rname="libtommath"
rver="1.2.1"
rdir="${rname}-${rver}"
rfile="ltm-${rver}.tar.xz"
rurl="https://github.com/libtom/${rname}/releases/download/v${rver}/${rfile}"
rsha256="986025d7b374276fee2e30e99f3649e4ac0db8a02257a37ee10eae72abed0d1f"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} -f makefile.unix PREFIX=\"${ridir}\" CC=\"\${CC}\" CFLAGS=\"\${CFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -f makefile.unix PREFIX=\"${ridir}\" CC=\"\${CC}\" CFLAGS=\"\${CFLAGS}\" install
  sed -i \"s,${ridir},${rtdir}/current,g\" \"${ridir}/lib/pkgconfig/${rname}.pc\"
  popd >/dev/null 2>&1
}
"

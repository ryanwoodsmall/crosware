rname="libtommath"
rver="1.2.0"
rdir="${rname}-${rver}"
rfile="ltm-${rver}.tar.xz"
rurl="https://github.com/libtom/${rname}/releases/download/v${rver}/${rfile}"
rsha256="b7c75eecf680219484055fcedd686064409254ae44bc31a96c5032843c0e18b1"
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

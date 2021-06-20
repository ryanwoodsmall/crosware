rname="libucontext"
rver="1.1"
rdir="${rname}-${rver}"
rbdir="${cwbuild}/${rname}-${rdir}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/kaniini/${rname}/archive/refs/tags/${rfile}"
rsha256="298201cef024aee29dfb81c3f1ef800047d5c799297651a60e2c53bb76956ea6"
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
  env CPPFLAGS= LDFLAGS=-static make LIBDIR=\"${ridir}/lib\" INCLUDEDIR=\"${ridir}/include\" PKGCONFIGDIR=\"${ridir}/lib/pkgconfig\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static make install LIBDIR=\"${ridir}/lib\" INCLUDEDIR=\"${ridir}/include\" PKGCONFIGDIR=\"${ridir}/lib/pkgconfig\"
  rm -f ${ridir}/lib/*.so* || true
  popd >/dev/null 2>&1
}
"

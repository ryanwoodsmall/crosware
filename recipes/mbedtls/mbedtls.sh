rname="mbedtls"
rver="2.11.0"
rdir="${rname}-${rname}-${rver}"
rfile="${rname}-${rver}.tar.gz"
rurl="https://github.com/ARMmbed/${rname}/archive/${rfile}"
rsha256="50d715c4bf1c21757b25df192cdff6951a621b32da1c991b513c23b9ddf3333a"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG \"s#^DESTDIR=.*#DESTDIR=${ridir}#g\" Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make -j${cwmakejobs} no_test CC=\"\${CC}\" CFLAGS=\"\${CFLAGS}\" LDFLAGS=\"-static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"

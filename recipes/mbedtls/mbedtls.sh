rname="mbedtls"
rver="2.9.0"
rdir="${rname}-${rver}"
rfile="${rdir}-apache.tgz"
rurl="https://tls.mbed.org/download/${rfile}"
rsha256="a06a9b43e583b7e6707becfeeb13d88ed00f25fee31a5386cb3a3014c454bad8"
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
  make -j${cwmakejobs} no_test CC=\"\${CC}\" CFLAGS=\"-Wl,-static\" LDFLAGS=\"-static\"
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

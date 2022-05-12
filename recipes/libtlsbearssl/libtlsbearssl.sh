rname="libtlsbearssl"
rver="0.5"
rdir="libtls-bearssl-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/michaelforney/libtls-bearssl/releases/download/${rver}/${rfile}"
rsha256="8714ab140eff675931212c869bf6dae797516d0fead2d0884d49a6ca0ee11c23"
rreqs="bootstrapmake bearssl cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat Makefile > Makefile.ORIG
  sed -i 's,/usr/local,${ridir},g' Makefile
  sed -i '/^install:/s,install-shared,,g' Makefile
  sed -i.ORIG 's,/etc/ssl/cert.pem,${cwetc}/ssl/cert.pem,g' tls_internal.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} CC=\"\${CC} -I${cwsw}/bearssl/current/include -L${cwsw}/bearssl/current/lib\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  rm -f \"${ridir}/lib/pkgconfig/libtls.pc\" || true
  make install
  sed -i 's,${ridir},${rtdir}/current,g' \"${ridir}/lib/pkgconfig/libtls.pc\"
  sed -i 's,-lbearssl,-L${cwsw}/bearssl/current/lib -lbearssl,g' \"${ridir}/lib/pkgconfig/libtls.pc\"
  popd >/dev/null 2>&1
}
"

# eval "
# function cwgenprofd_${rname}() {
#   echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
#   echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
#   echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
# }
# "

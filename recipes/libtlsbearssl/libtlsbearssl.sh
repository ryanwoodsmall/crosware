rname="libtlsbearssl"
rver="0.6"
rdir="libtls-bearssl-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/michaelforney/libtls-bearssl/releases/download/${rver}/${rfile}"
rsha256="b5becdfbab7e849a145c0caf94be8bbf8c89be9d7e0479e13e65bab5b5b875ab"
rreqs="bootstrapmake bearssl cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  cat Makefile > Makefile.ORIG
  sed -i 's,/usr/local,${ridir},g' Makefile
  sed -i '/^install:/s,install-shared,,g' Makefile
  sed -i.ORIG 's,/etc/ssl/cert.pem,${cwetc}/ssl/cert.pem,g' tls_internal.h
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make -j${cwmakejobs} ${rlibtool} CC=\"\${CC} -I${cwsw}/bearssl/current/include -L${cwsw}/bearssl/current/lib\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  rm -f \"${ridir}/lib/pkgconfig/libtls.pc\" || true
  make install
  sed -i 's,${ridir},${rtdir}/current,g' \"${ridir}/lib/pkgconfig/libtls.pc\"
  sed -i 's,-lbearssl,-L${cwsw}/bearssl/current/lib -lbearssl,g' \"${ridir}/lib/pkgconfig/libtls.pc\"
  popd &>/dev/null
}
"

# eval "
# function cwgenprofd_${rname}() {
#   echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
#   echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
#   echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
# }
# "

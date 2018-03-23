#
# XXX - look at other ssl/tls providers
#   - polar, cyassl/wolfssl, axtls, gnutls, nss, mbedtls, ...
#

rname="curl"
rver="7.59.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://curl.haxx.se/download/${rfile}"
rsha256="b5920ffd6a8c95585fb95070e0ced38322790cb335c39d0dab852d12e157b5a0"
rreqs="make zlib openssl mbedtls"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --with-zlib --without-mbedtls --with-ssl --with-default-ssl-backend=openssl
  popd >/dev/null 2>&1
}
"

#
# XXX - need to split this out for tls/ssl provider
#
eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make install
  make distclean
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --with-zlib --without-ssl --with-mbedtls --with-default-ssl-backend=mbedtls
  make -j$(($(nproc)+1))
  install -m 0755 src/curl ${ridir}/bin/curl-mbedtls
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"

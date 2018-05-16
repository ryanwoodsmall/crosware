#
# - other ssl/tls providers
#   - axtls, gnutls, nss, ...
# - libssh2
#   - supports one of openssl, mbed, libgcrypt
#   - mix/match with ssl/tls providers? seems like a bad idea
#

rname="curl"
rver="7.60.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://curl.haxx.se/download/${rfile}"
rsha256="897dfb2204bd99be328279f88f55b7c61592216b0542fcbe995c60aa92871e9b"
rreqs="make zlib openssl mbedtls wolfssl libssh2"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-libssh2 \
    --with-zlib \
    --without-mbedtls \
    --without-cyassl \
    --with-ssl \
    --with-default-ssl-backend=openssl
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
  popd >/dev/null 2>&1
  cwmakeinstall_${rname}_mbedtls
  cwmakeinstall_${rname}_wolfssl
}
"

#
# XXX - ugly
#
eval "
function cwmakeinstall_${rname}_mbedtls() {
  pushd "${rbdir}" >/dev/null 2>&1
  make distclean
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-zlib \
    --without-libssh2 \
    --without-ssl \
    --without-cyassl \
    --with-mbedtls \
    --with-default-ssl-backend=mbedtls
  make -j${cwmakejobs}
  install -m 0755 src/curl ${ridir}/bin/curl-mbedtls
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}_wolfssl() {
  pushd "${rbdir}" >/dev/null 2>&1
  make distclean
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-zlib \
    --without-libssh2 \
    --without-ssl \
    --without-mbedtls \
    --with-cyassl \
    --with-default-ssl-backend=cyassl
  make -j${cwmakejobs}
  install -m 0755 src/curl ${ridir}/bin/curl-wolfssl
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

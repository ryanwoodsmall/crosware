#
# - other ssl/tls providers
#   - gnutls, nss, ...
# - libssh2
#   - supports one of openssl, mbed, libgcrypt
#   - mix/match with ssl/tls providers? seems like a bad idea
#

rname="curl"
rver="7.65.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://curl.haxx.se/download/${rfile}"
rsha256="ea47c08f630e88e413c85793476e7e5665647330b6db35f5c19d72b3e339df5c"
rreqs="make zlib openssl mbedtls wolfssl libssh2 expat libmetalink"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-dependency-tracking \
    --disable-maintainer-mode \
    --with-libmetalink \
    --with-libssh2 \
    --with-zlib \
    --without-mbedtls \
    --without-cyassl \
    --without-gnutls \
    --with-ssl \
    --with-default-ssl-backend=openssl \
      LIBS='-lexpat'
  popd >/dev/null 2>&1
}
"

#
# XXX - need to split this out for tls/ssl provider
#
eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  rm -f \"${ridir}/bin/${rname}\" \"${ridir}/bin/${rname}-openssl\"
  make install
  popd >/dev/null 2>&1
  mv \"${ridir}/bin/${rname}\" \"${ridir}/bin/${rname}-openssl\"
  ln -sf \"${rtdir}/current/bin/${rname}-openssl\" \"${ridir}/bin/${rname}\"
  cwmakeinstall_${rname}_mbedtls
  cwmakeinstall_${rname}_wolfssl
}
"

#
# XXX - ugly
#
eval "
function cwmakeinstall_${rname}_mbedtls() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make distclean || true
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-dependency-tracking \
    --disable-maintainer-mode \
    --with-zlib \
    --without-libmetalink \
    --without-libssh2 \
    --without-ssl \
    --without-cyassl \
    --without-gnutls \
    --with-mbedtls \
    --with-default-ssl-backend=mbedtls
  make -j${cwmakejobs}
  mkdir -p ${ridir}/bin
  install -m 0755 src/curl ${ridir}/bin/curl-mbedtls
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}_wolfssl() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make distclean || true
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-dependency-tracking \
    --disable-maintainer-mode \
    --with-zlib \
    --without-libmetalink \
    --without-libssh2 \
    --without-ssl \
    --without-mbedtls \
    --without-gnutls \
    --with-cyassl \
    --with-default-ssl-backend=cyassl
  make -j${cwmakejobs}
  mkdir -p ${ridir}/bin
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

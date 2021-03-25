#
# - other ssl/tls providers
#   - gnutls, nss, ...
# - libssh2
#   - supports one of openssl, mbed, libgcrypt
#   - mix/match with ssl/tls providers? seems like a bad idea
# - wolfssh support
#   - --with-wolfssh
# - enable libidn2?
# - enable c-ares resolver?
# - add ngtcp2+nghttp3 (experimental, really needs openssl?)
# - zstd support?
#

rname="curl"
rver="7.75.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://curl.haxx.se/download/${rfile}"
rsha256="50552d4501c178e4cc68baaecc487f466a3d6d19bbf4e50a01869effb316d026"
rreqs="make zlib openssl libressl bearssl mbedtls wolfssl libssh2 expat libmetalink cacertificates nghttp2"

. "${cwrecipe}/common.sh"

# ugly - multiple configs need this, can't rely on base openssl cwconfigure_curl running
eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  pushd \"${rbdir}\" >/dev/null 2>&1
  #local ossldir=\"\$(${cwsw}/openssl/current/bin/openssl version -d | cut -f2 -d' ' | tr -d '\"')\"
  local ossldir=\"${cwetc}/ssl\"
  local cabundle=\"\${ossldir}/cert.pem\"
  sed -i.ORIG \"s#/etc/ssl/cert#\${ossldir}/cert#g\" configure
  sed -i \"/ \\/.*\\/ca-.*\\.crt/s# /.*/ca-.*crt# \${cabundle}#g\" configure
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-dependency-tracking \
    --disable-maintainer-mode \
    --enable-ipv6 \
    --with-libmetalink \
    --with-libssh2 \
    --with-nghttp2 \
    --with-zlib \
    --without-hyper \
    --without-libidn2 \
    --without-zstd \
    --without-bearssl \
    --without-mbedtls \
    --without-wolfssl \
    --without-gnutls \
    --with-ssl \
    --with-default-ssl-backend=openssl \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\"  \
    --with-ca-path=\"${cwetc}/ssl/certs\" \
    --with-ca-fallback \
      LIBS='-L${cwsw}/expat/current/lib -lexpat'
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
  cwmakeinstall_${rname}_libressl
  cwmakeinstall_${rname}_bearssl
  cwmakeinstall_${rname}_mbedtls
  cwmakeinstall_${rname}_wolfssl
}
"

#
# XXX - ugly
#
eval "
function cwmakeinstall_${rname}_libressl() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make distclean || true
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-dependency-tracking \
    --disable-maintainer-mode \
    --enable-ipv6 \
    --with-nghttp2 \
    --with-zlib \
    --without-hyper \
    --without-libidn2 \
    --without-zstd \
    --without-libmetalink \
    --without-libssh2 \
    --without-bearssl \
    --with-ssl \
    --without-wolfssl \
    --without-gnutls \
    --without-mbedtls \
    --with-default-ssl-backend=openssl \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
    --with-ca-path=\"${cwetc}/ssl/certs\" \
      LDFLAGS=\"-L${cwsw}/zlib/current/lib -L${cwsw}/libressl/current/lib -static\" \
      CPPFLAGS=\"-I${cwsw}/zlib/current/include -I${cwsw}/libressl/current/include\" \
      PKG_CONFIG_PATH=\"${cwsw}/nghttp2/current/lib/pkgconfig\" \
      PKG_CONFIG_LIBDIR=\"${cwsw}/nghttp2/current/lib/pkgconfig\"
  make -j${cwmakejobs}
  mkdir -p ${ridir}/bin
  install -m 0755 src/curl ${ridir}/bin/curl-libressl
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}_mbedtls() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make distclean || true
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-dependency-tracking \
    --disable-maintainer-mode \
    --enable-ipv6 \
    --with-nghttp2 \
    --with-zlib \
    --without-hyper \
    --without-libidn2 \
    --without-zstd \
    --without-libmetalink \
    --without-libssh2 \
    --without-bearssl \
    --without-ssl \
    --without-wolfssl \
    --without-gnutls \
    --with-mbedtls \
    --with-default-ssl-backend=mbedtls \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
    --with-ca-path=\"${cwetc}/ssl/certs\"
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
    --enable-ipv6 \
    --with-nghttp2 \
    --with-zlib \
    --without-hyper \
    --without-libidn2 \
    --without-zstd \
    --without-libmetalink \
    --without-libssh2 \
    --without-bearssl \
    --without-ssl \
    --without-mbedtls \
    --without-gnutls \
    --with-wolfssl \
    --with-default-ssl-backend=wolfssl \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
    --with-ca-path=\"${cwetc}/ssl/certs\"
  make -j${cwmakejobs}
  mkdir -p ${ridir}/bin
  install -m 0755 src/curl ${ridir}/bin/curl-wolfssl
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}_bearssl() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make distclean || true
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-dependency-tracking \
    --disable-maintainer-mode \
    --enable-ipv6 \
    --with-nghttp2 \
    --with-zlib \
    --without-hyper \
    --without-libidn2 \
    --without-zstd \
    --without-libmetalink \
    --without-libssh2 \
    --without-ssl \
    --without-mbedtls \
    --without-gnutls \
    --without-wolfssl \
    --with-bearssl \
    --with-default-ssl-backend=bearssl \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
    --with-ca-path=\"${cwetc}/ssl/certs\"
  make -j${cwmakejobs}
  mkdir -p ${ridir}/bin
  install -m 0755 src/curl ${ridir}/bin/curl-bearssl
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

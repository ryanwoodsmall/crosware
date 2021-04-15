#
# - other ssl/tls providers
#   - gnutls, nss, ...
# - libssh2
#   - main package supports openssl
#   - copy of libssh2 bundled with libressl recipe (with own curl)
#   - other providers use libssh2libgcrypt
#     - requires libgcrypt, which needs libgpgerror
#     - libssh2 w/libgcrypt needs '-u user: --key id_rsa --pubkey id_rsa.pub' options?
#     - https://www.zufallsheld.de/2020/06/07/debugging-issues-libcurl-pubkey-authentication/
# - enable libidn2?
# - enable c-ares resolver?
# - add ngtcp2+nghttp3 (experimental, really needs openssl (with patches)? gnutls?)
# - zstd support?
# - brotli?
#

rname="curl"
rver="7.76.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://curl.haxx.se/download/${rfile}"
rsha256="7a8e184d7d31312c4ebf6a8cb59cd757e61b2b2833a9ed4f9bf708066e7695e9"
rreqs="make zlib openssl libressl bearssl mbedtls wolfssl libssh2 expat libmetalink cacertificates nghttp2 pkgconfig libgpgerror libgcrypt libssh2libgcrypt"

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
    --with-libmetalink=\"${cwsw}/libmetalink/current\" \
    --with-libssh2=\"${cwsw}/libssh2/current\" \
    --with-nghttp2=\"${cwsw}/nghttp2/current\" \
    --with-zlib=\"${cwsw}/zlib/current\" \
    --without-hyper \
    --without-libidn2 \
    --without-zstd \
    --without-bearssl \
    --without-mbedtls \
    --without-wolfssh \
    --without-wolfssl \
    --without-gnutls \
    --with-ssl=\"${cwsw}/openssl/current\" \
    --with-default-ssl-backend=openssl \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\"  \
    --with-ca-path=\"${cwetc}/ssl/certs\" \
    --with-ca-fallback \
      LIBS='-L${cwsw}/expat/current/lib -lexpat'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmakeinstall_${rname}_openssl
  cwmakeinstall_${rname}_libressl
  cwmakeinstall_${rname}_bearssl
  cwmakeinstall_${rname}_mbedtls
  cwmakeinstall_${rname}_wolfssl
}
"

eval "
function cwmakeinstall_${rname}_openssl() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  rm -f \"${ridir}/bin/${rname}\" \"${ridir}/bin/${rname}-openssl\"
  make install
  mv \"${ridir}/bin/${rname}\" \"${ridir}/bin/${rname}-openssl\"
  ln -sf \"${rtdir}/current/bin/${rname}-openssl\" \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

#
# XXX - ugly
#

#
# XXX - we build a dedicated curl as part of libressl, just use it if it's the same version
# XXX - options could get out of whack here
# XXX - might be better to just run cwupgrade_libressl and use it if no version match???
#
eval "
function cwmakeinstall_${rname}_libressl() {
  if [ -e \"${cwsw}/libressl/current/bin/curl-config\" ] ; then
    if [[ \$(${cwsw}/libressl/current/bin/curl-config --version | cut -f2 -d' ') =~ ^${rver}$ ]] ; then
      cwmkdir \"${ridir}/bin\"
      rm -f  \"${ridir}/bin/curl-libressl\"
      install -m 0755 \"\$(realpath ${cwsw}/libressl/current/bin/curl-libressl)\" \"${ridir}/bin/curl-libressl\"
      return
    fi
  fi
  pushd \"${rbdir}\" >/dev/null 2>&1
  make distclean || true
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-dependency-tracking \
    --disable-maintainer-mode \
    --enable-ipv6 \
    --with-libssh2=\"${cwsw}/libressl/current\" \
    --with-nghttp2=\"${cwsw}/nghttp2/current\" \
    --with-zlib=\"${cwsw}/zlib/current\" \
    --without-hyper \
    --without-libidn2 \
    --without-zstd \
    --without-libmetalink \
    --without-bearssl \
    --with-ssl=\"${cwsw}/libressl/current\" \
    --without-wolfssh \
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
    --with-libssh2=\"${cwsw}/libssh2libgcrypt/current\" \
    --with-nghttp2=\"${cwsw}/nghttp2/current\" \
    --with-zlib=\"${cwsw}/zlib/current\" \
    --without-hyper \
    --without-libidn2 \
    --without-zstd \
    --without-libmetalink \
    --without-bearssl \
    --without-ssl \
    --without-wolfssh \
    --without-wolfssl \
    --without-gnutls \
    --with-mbedtls=\"${cwsw}/mbedtls/current\" \
    --with-default-ssl-backend=mbedtls \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
    --with-ca-path=\"${cwetc}/ssl/certs\" \
      CPPFLAGS=\"$(echo -I${cwsw}/{mbedtls,zlib,nghttp2,libgpgerror,libgcrypt,libssh2libgcrypt}/current/include)\" \
      LDFLAGS=\"$(echo -L${cwsw}/{mbedtls,zlib,nghttp2,libgpgerror,libgcrypt,libssh2libgcrypt}/current/lib) -static\" \
      PKG_CONFIG_LIBDIR=\"$(echo ${cwsw}/{mbedtls,zlib,nghttp2,libgpgerror,libgcrypt,libssh2libgcrypt}/current/lib/pkgconfig | tr ' ' ':')\" \
      PKG_CONFIG_PATH=\"$(echo ${cwsw}/{mbedtls,zlib,nghttp2,libgpgerror,libgcrypt,libssh2libgcrypt}/current/lib/pkgconfig | tr ' ' ':')\"
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
    --with-libssh2=\"${cwsw}/libssh2libgcrypt/current\" \
    --with-nghttp2=\"${cwsw}/nghttp2/current\" \
    --with-zlib=\"${cwsw}/zlib/current\" \
    --without-hyper \
    --without-libidn2 \
    --without-zstd \
    --without-libmetalink \
    --without-bearssl \
    --without-ssl \
    --without-mbedtls \
    --without-gnutls \
    --without-wolfssh \
    --with-wolfssl=\"${cwsw}/wolfssl/current\" \
    --with-default-ssl-backend=wolfssl \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
    --with-ca-path=\"${cwetc}/ssl/certs\" \
      CPPFLAGS=\"$(echo -I${cwsw}/{wolfssl,zlib,nghttp2,libgpgerror,libgcrypt,libssh2libgcrypt}/current/include)\" \
      LDFLAGS=\"$(echo -L${cwsw}/{wolfssl,zlib,nghttp2,libgpgerror,libgcrypt,libssh2libgcrypt}/current/lib) -static\" \
      PKG_CONFIG_LIBDIR=\"$(echo ${cwsw}/{wolfssl,zlib,nghttp2,libgpgerror,libgcrypt,libssh2libgcrypt}/current/lib/pkgconfig | tr ' ' ':')\" \
      PKG_CONFIG_PATH=\"$(echo ${cwsw}/{wolfssl,zlib,nghttp2,libgpgerror,libgcrypt,libssh2libgcrypt}/current/lib/pkgconfig | tr ' ' ':')\"
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
    --with-libssh2=\"${cwsw}/libssh2libgcrypt/current\" \
    --with-nghttp2=\"${cwsw}/nghttp2/current\" \
    --with-zlib=\"${cwsw}/zlib/current\" \
    --without-hyper \
    --without-libidn2 \
    --without-zstd \
    --without-libmetalink \
    --without-ssl \
    --without-mbedtls \
    --without-gnutls \
    --without-wolfssh \
    --without-wolfssl \
    --with-bearssl=\"${cwsw}/bearssl/current\" \
    --with-default-ssl-backend=bearssl \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
    --with-ca-path=\"${cwetc}/ssl/certs\" \
      CPPFLAGS=\"$(echo -I${cwsw}/{bearssl,zlib,nghttp2,libgpgerror,libgcrypt,libssh2libgcrypt}/current/include)\" \
      LDFLAGS=\"$(echo -L${cwsw}/{bearssl,zlib,nghttp2,libgpgerror,libgcrypt,libssh2libgcrypt}/current/lib) -static\" \
      PKG_CONFIG_LIBDIR=\"$(echo ${cwsw}/{bearssl,zlib,nghttp2,libgpgerror,libgcrypt,libssh2libgcrypt}/current/lib/pkgconfig | tr ' ' ':')\" \
      PKG_CONFIG_PATH=\"$(echo ${cwsw}/{bearssl,zlib,nghttp2,libgpgerror,libgcrypt,libssh2libgcrypt}/current/lib/pkgconfig | tr ' ' ':')\"
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

#
# - other ssl/tls providers
#   - gnutls, nss, ...
# - libssh2
#   - doesn't support some newer elliptic curve stuff yet...
#   - ... libssh does, but needs cmake, so no way
#   - main package supports openssl
#   - copy of libssh2 bundled with libressl recipe
#   - other providers use libssh2libgcrypt
#     - requires libgcrypt, which needs libgpgerror
#     - libssh2 w/libgcrypt OR mbedtls need '--key id_rsa --pubkey id_rsa.pub' options
#     - https://www.zufallsheld.de/2020/06/07/debugging-issues-libcurl-pubkey-authentication/
# - enable libidn2?
# - add ngtcp2+nghttp3 (experimental, really needs openssl (with patches)? gnutls?)
# - zstd support?
# - brotli?
#
# XXX - lots of accreted workarounds. need centralization for e.g. sched_yield(), bearssl, etc. workarounds
# XXX - stdatomic.h / -latomic fixes...
# XXX - enable c-ares resolver - necessary for dns overrides!
#       - curl: option --dns-servers: the installed libcurl version doesn't support this
#       - https://github.com/curl/curl/issues/8551
#

rname="curl"
rver="8.6.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://curl.se/download/${rfile}"
rsha256="9c6db808160015f30f3c656c0dec125feb9dc00753596bf858a272b5dd8dc398"
rreqs="make zlib openssl libssh2 cacertificates nghttp2 pkgconfig"

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

# XXX - ugh, sched.h needs to be included for sched_yield, breaks arm32
eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  echo '#include <sched.h>' >> lib/curl_config.h.in
  echo '#include <stdatomic.h>' >> lib/curl_config.h.in
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-dependency-tracking \
    --disable-maintainer-mode \
    --enable-headers-api \
    --enable-ipv6 \
    --with-libssh2=\"${cwsw}/libssh2/current\" \
    --with-nghttp2=\"${cwsw}/nghttp2/current\" \
    --with-zlib=\"${cwsw}/zlib/current\" \
    --without-brotli \
    --without-hyper \
    --without-libidn2 \
    --without-libpsl \
    --without-zstd \
    --without-bearssl \
    --without-mbedtls \
    --without-wolfssh \
    --without-wolfssl \
    --without-gnutls \
    --with-openssl=\"${cwsw}/openssl/current\" \
    --with-default-ssl-backend=openssl \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\"  \
    --with-ca-path=\"${cwetc}/ssl/certs\" \
    --with-ca-fallback \
      LIBS='-latomic'
  echo '#include <sched.h>' >> lib/curl_config.h
  echo '#include <stdatomic.h>' >> lib/curl_config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmakeinstall_${rname}_openssl
}
"

eval "
function cwmakeinstall_${rname}_openssl() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  rm -f \"${ridir}/bin/${rname}\" \"${ridir}/bin/${rname}-openssl\"
  make install
  mv \"${ridir}/bin/${rname}\" \"${ridir}/bin/${rname}-openssl\"
  ln -sf \"${rtdir}/current/bin/${rname}-openssl\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}-openssl\" \"${ridir}/bin/${rname}openssl\"
  sed -i 's/ -lcurl / -lcurl -latomic /g' \"\$(cwidir_${rname})/lib/pkgconfig/libcurl.pc\"
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

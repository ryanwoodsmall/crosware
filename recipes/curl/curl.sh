#
# - other ssl/tls providers
#   - nss, ...
# - libssh2
#   - libssh supports (more?) ecc stuff, but needs cmake, so no way
#   - main package supports openssl
#   - libressl, mbedtls, wolfssl variants
#   - other providers use libssh2libgcrypt
#     - requires libgcrypt, which needs libgpgerror
#     - libssh2 w/libgcrypt OR mbedtls need '--key id_rsa --pubkey id_rsa.pub' options
#     - https://www.zufallsheld.de/2020/06/07/debugging-issues-libcurl-pubkey-authentication/
# - add ngtcp2+nghttp3 (experimental, really needs openssl (with patches)? gnutls?)
# - zstd support?
# - brotli?
#
# XXX - need a 'curlstandalone' w/zlib+nghttp2+mbedtls and embedded ca only
#
# XXX - lots of accreted workarounds. need centralization for e.g. sched_yield(), bearssl, etc. workarounds
# XXX - stdatomic.h / -latomic fixes...
# XXX - enable c-ares resolver - necessary for dns overrides!
#       - curl: option --dns-servers: the installed libcurl version doesn't support this
#       - https://github.com/curl/curl/issues/8551
# XXX - libpsl support is enabled by default now; it requires libidn2, libunistring and a python, explicitly disable...
# XXX - mbedtls is messy at/after fba9afebba22d577f122239b184edc90c18fd81b (bisected) - need to figure out why
#
rname="curl"
rver="8.11.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://curl.se/download/${rfile}"
rurl="https://github.com/curl/curl/releases/download/curl-${rver//./_}/${rfile}"
rsha256="264537d90e58d2b09dddc50944baf3c38e7089151c8986715e2aaeaaf2b8118f"
rreqs="make zlib openssl libssh2 cacertificates nghttp2 pkgconfig caextract"

. "${cwrecipe}/common.sh"

# ugly - multiple configs need this, can't rely on base openssl cwconfigure_curl running
eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  #local ossldir=\"\$(${cwsw}/openssl/current/bin/openssl version -d | cut -f2 -d' ' | tr -d '\"')\"
  local ossldir=\"${cwetc}/ssl\"
  local cabundle=\"\${ossldir}/cert.pem\"
  sed -i.ORIG \"s#/etc/ssl/cert#\${ossldir}/cert#g\" configure
  sed -i \"/ \\/.*\\/ca-.*\\.crt/s# /.*/ca-.*crt# \${cabundle}#g\" configure
  popd &>/dev/null
}
"

# XXX - ugh, sched.h needs to be included for sched_yield, breaks arm32
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  local e='--enable-docs --enable-manual'
  if ! command -v perl &>/dev/null ; then
    cwfuncecho 'no perl; disabling docs/manual'
    e='--disable-docs --disable-manual'
    sed -i '/SUBDIRS.*docs/s,\\(docs\\|cmdline-opts\\),,g' Makefile.in
    sed -i '/SUBDIRS.*docs/s,../docs,,g' src/Makefile.in
    sed -i 's,^SUBDIRS.*,SUBDIRS=libcurl,g' docs/Makefile.in
  fi
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
    --with-ca-embed=\"\$(realpath ${cwsw}/caextract/current/cert.pem)\" \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\"  \
    --with-ca-path=\"${cwetc}/ssl/certs\" \
    --with-ca-fallback \
      \${e} \
      LIBS='-latomic'
  echo '#include <sched.h>' >> lib/curl_config.h
  echo '#include <stdatomic.h>' >> lib/curl_config.h
  unset e
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmakeinstall_${rname}_openssl
}
"

eval "
function cwmakeinstall_${rname}_openssl() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  rm -f \$(cwidir_${rname})/bin/${rname}{,{,-}openssl}
  make install
  mv \"\$(cwidir_${rname})/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-openssl\"
  ln -sf \"${rtdir}/current/bin/${rname}-openssl\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}-openssl\" \"\$(cwidir_${rname})/bin/${rname}openssl\"
  sed -i 's/ -lcurl / -lcurl -latomic /g' \"\$(cwidir_${rname})/lib/pkgconfig/libcurl.pc\"
  popd &>/dev/null
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

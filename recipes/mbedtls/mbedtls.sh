#
# XXX - need to require and enable zlib? probably not? deprecated?
# XXX - alpine still tracking 2.16.x, maybe stick with that
# XXX - 2.23.x lts needs some changes to _not_ require python3...
#  cat programs/Makefile > programs/Makefile.ORIG
#  sed -i '/^\\tpsa\\/key_ladder_demo.*\\$/d' programs/Makefile
#  sed -i '/^\\tpsa\\/psa_constant_name.*\\$/d' programs/Makefile
# XXX - is threading right?
#  see alpine: https://git.alpinelinux.org/aports/tree/main/mbedtls/APKBUILD
# XXX - generate a self-signed cert for like localhost?
#  https://tls.mbed.org/kb/how-to/generate-a-self-signed-certificate
# XXX - options?
#  - MBEDTLS_SSL_SRV_SUPPORT_SSLV2_CLIENT_HELLO
#  - MBEDTLS_SSL_SRV_RESPECT_CLIENT_PREFERENCE
#  - MBEDTLS_SSL_PROTO_SSL3
#  - MBEDTLS_ARIA_C
#  - MBEDTLS_CMAC_C
#  - MBEDTLS_ECJPAKE_C
#  - MBEDTLS_NIST_KW_C
#  - MBEDTLS_MD2_C
#  - MBEDTLS_MD4_C
#

rname="mbedtls"
rver="2.16.11"
rdir="${rname}-${rname}-${rver}"
rfile="${rname}-${rver}.tar.gz"
rurl="https://github.com/ARMmbed/${rname}/archive/${rfile}"
rsha256="51bb9685c4f4ff9255da5659ff346b89dcaf129e3ba0f3b2b0c48a1a7495e701"
rreqs="make cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG \"s#^DESTDIR=.*#DESTDIR=${ridir}#g\" Makefile
  cat include/mbedtls/config.h > include/mbedtls/config.h.ORIG
  sed -i '/define MBEDTLS_THREADING_C/s,//,,g' include/mbedtls/config.h
  sed -i '/define MBEDTLS_THREADING_PTHREAD/s,//,,g' include/mbedtls/config.h
  sed -i '/define MBEDTLS_X509_ALLOW_UNSUPPORTED_CRITICAL_EXTENSION/s,//,,g' include/mbedtls/config.h
  sed -i '/define MBEDTLS_X509_ALLOW_EXTENSIONS_NON_V3/s,//,,g' include/mbedtls/config.h
  sed -i '/define MBEDTLS_TLS_DEFAULT_ALLOW_SHA1_IN_CERTIFICATES/s,//,,g' include/mbedtls/config.h
  sed -i '/define MBEDTLS_ENABLE_WEAK_CIPHERSUITES/s,//,,g' include/mbedtls/config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} no_test CC=\"\${CC}\" CFLAGS=\"\${CFLAGS}\" LDFLAGS=\"-static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"

#
# XXX - 2.16.12 is the last release of the 2.16 lts branch!!!
# XXX - 2.28.x is new lts as of 202112
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
# XXX - mbedtls 3.x...
#

rname="mbedtls"
rver="2.16.12"
rdir="${rname}-${rname}-${rver}"
rfile="${rname}-${rver}.tar.gz"
rurl="https://github.com/ARMmbed/${rname}/archive/${rfile}"
rsha256="0afb4a4ce5b771f2fb86daee786362fbe48285f05b73cd205f46a224ec031783"
rreqs="make cacertificates"

. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"

#
# XXX - alpine still tracking 2.16.x
# XXX - is threading right?
#  see alpine: https://git.alpinelinux.org/aports/tree/main/mbedtls/APKBUILD
# XXX - generate a self-signed cert for like localhost?
#  https://tls.mbed.org/kb/how-to/generate-a-self-signed-certificate
#  https://tls.mbed.org/kb/how-to/generate-a-certificate-request-csr
#  https://wiki.archlinux.org/title/Mbed_TLS
#    mbedtls_cert_write selfsign=1 issuer_key=private_key issuer_name=subject not_before=YYYYMMDDHHMMSS not_after=YYYYMMDDHHMMSS is_ca=1 max_pathlen=0 output_file=file
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
rver="2.28.0"
rdir="${rname}-${rname}-${rver}"
rfile="${rname}-${rver}.tar.gz"
rurl="https://github.com/ARMmbed/${rname}/archive/${rfile}"
rsha256="f644248f23cf04315cf9bb58d88c4c9471c16ca0533ecf33f86fb7749a3e5fa6"

. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"

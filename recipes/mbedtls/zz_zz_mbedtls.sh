#
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
#
rname="mbedtls"
rpv="2"
rpn="${rname}${rpv}"
rver="$(cwver_${rpn})"
rdir="$(cwdir_${rpn})"
rfile="$(cwfile_${rpn})"
rdlfile="$(cwdlfile_${rpn})"
rurl="$(cwurl_${rpn})"
rsha256="$(cwsha256_${rpn})"
rreqs="${rpn}"

. "${cwrecipe}/common.sh"

for f in fetch clean extract configure make ; do
  cwstubfunc "cw${f}_${rname}"
done
unset f

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${rtdir}\"
  rm -rf \"${rtdir}/current\"
  rm -rf \"\$(cwidir_${rname})\"
  ln -sf \"\$(cwidir_${rpn})\" \"\$(cwidir_${rname})\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"

unset rpv
unset rpn

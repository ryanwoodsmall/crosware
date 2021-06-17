#
# XXX - libressl doesn't have SSL_CTX_set1_verify_cert_store - not sure of workaround (via ssl.h):
#   #define SSL_CTRL_SET_VERIFY_CERT_STORE 106
#   #define SSL_CTX_set1_verify_cert_store(ctx,st) SSL_CTX_ctrl(ctx,SSL_CTRL_SET_VERIFY_CERT_STORE,1,(char *)(st))
#

rname="hitch"
rver="1.7.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://hitch-tls.org/source/${rfile}"
rsha256="c97ef8f1e115156640c40dfdfe9662d5f6d57a796fccad3bbad198ec797ce5c4"
rreqs="make openssl libev pkgconfig zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --enable-tcp-fastopen
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"

#
# XXX - libressl doesn't have SSL_CTX_set1_verify_cert_store - not sure of workaround (via ssl.h):
#   #define SSL_CTRL_SET_VERIFY_CERT_STORE 106
#   #define SSL_CTX_set1_verify_cert_store(ctx,st) SSL_CTX_ctrl(ctx,SSL_CTRL_SET_VERIFY_CERT_STORE,1,(char *)(st))
#

rname="hitch"
rver="1.7.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://hitch-tls.org/source/${rfile}"
rsha256="1a1bf4955d775b718dc31c89a1a05176530b0ca856f95ee42a2bc7a23f289787"
rreqs="make openssl libev pkgconfig zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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

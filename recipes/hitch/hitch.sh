#
# XXX - libressl doesn't have SSL_CTX_set1_verify_cert_store - not sure of workaround (via ssl.h):
#   #define SSL_CTRL_SET_VERIFY_CERT_STORE 106
#   #define SSL_CTX_set1_verify_cert_store(ctx,st) SSL_CTX_ctrl(ctx,SSL_CTRL_SET_VERIFY_CERT_STORE,1,(char *)(st))
#

rname="hitch"
rver="1.8.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://hitch-tls.org/source/${rfile}"
rsha256="dfc99484bc7ffea27a3169e84d6c217988eda47b208ab2e5524dc2a5dd158f4e"
rreqs="make openssl libev pkgconfig zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --enable-tcp-fastopen \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"

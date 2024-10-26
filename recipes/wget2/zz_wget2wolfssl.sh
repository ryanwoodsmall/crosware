rname="wget2wolfssl"
rver="$(cwver_wget2)"
rdir="$(cwdir_wget2)"
rfile="$(cwfile_wget2)"
rurl="$(cwurl_wget2)"
rsha256="$(cwsha256_wget2)"

. "${cwrecipe}/${rname%wolfssl}/${rname%wolfssl}.sh.common"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwpatch_wget2
  sed -i '/XFREE.*subject/s,XFREE.*,if(subject) free(subject);,' libwget/ssl_wolfssl.c
  sed -i '/XFREE.*issuer/s,XFREE.*,if(issuer) free(issuer);,' libwget/ssl_wolfssl.c
  popd &>/dev/null
}
"

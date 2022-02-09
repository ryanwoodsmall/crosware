rname="tinycurl772"
rver="7.72.0"
rdir="tiny-curl-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://curl.se/tiny/${rfile}"
rsha256="f903cfcd008615d194f80a2b1c1f261609cea9c764eb9daaff92bf99040f7730"
rreqs="wolfssl libssh2wolfssl"
. "${cwrecipe}/${rname%772}/${rname%772}.sh.common"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/addcflags.*wolfssl/s,\$addcflags,-I${cwsw}/wolfssl/current/include,g' configure
  popd >/dev/null 2>&1
}
"

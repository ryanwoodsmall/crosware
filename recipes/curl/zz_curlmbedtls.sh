rname="curlmbedtls"
rreqs="mbedtls"
libssh2provider="libssh2mbedtls"
. "${cwrecipe}/${rname%mbedtls}/${rname%mbedtls}tlsprovider.sh.common"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG s,ALPN_H2_LEN,ALPN_H2_LENGTH,g lib/vtls/mbedtls.c
  popd >/dev/null 2>&1
}
"

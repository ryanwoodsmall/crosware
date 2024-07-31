#
# XXX - curl 8.8.x requires mbedtls 3.x, breaks with 3.6
# XXX - curl 8.9.x segfaults
# XXX - nothing newer than 8.7.x works without the main CA cert being present
# XXX - broken shit
#
rname="curlmbedtls"
rver="8.7.1"
rdir="${rname%mbedtls}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/curl/curl/releases/download/curl-${rver//./_}/${rfile}"
rsha256="f91249c87f68ea00cf27c44fdfa5a78423e41e71b7d408e5901a9896d905c495"
rreqs="mbedtls"
libssh2provider="libssh2mbedtls"
. "${cwrecipe}/${rname%mbedtls}/${rname%mbedtls}tlsprovider.sh.common"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rbdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
}
"

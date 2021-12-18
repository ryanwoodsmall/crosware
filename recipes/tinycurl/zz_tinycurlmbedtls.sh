rname="tinycurlmbedtls"
rver="$(cwver_tinycurl)"
rdir="$(cwdir_tinycurl)"
rfile="$(cwfile_tinycurl)"
rdlfile="$(cwdlfile_tinycurl)"
rurl="$(cwurl_tinycurl)"
rsha256=""
rreqs="make mbedtls libssh2mbedtls zlib"

. "${cwrecipe}/tinycurl/tinycurl.sh.common"

for f in fetch clean extract make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%mbedtls}
  }
  "
done
unset f

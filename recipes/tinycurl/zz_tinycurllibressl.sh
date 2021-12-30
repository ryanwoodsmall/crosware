rname="tinycurllibressl"
rver="$(cwver_tinycurl)"
rdir="$(cwdir_tinycurl)"
rfile="$(cwfile_tinycurl)"
rdlfile="$(cwdlfile_tinycurl)"
rurl="$(cwurl_tinycurl)"
rsha256=""
rreqs="libressl libssh2libressl"

. "${cwrecipe}/tinycurl/tinycurl.sh.common"

for f in fetch clean extract make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%libressl}
  }
  "
done
unset f

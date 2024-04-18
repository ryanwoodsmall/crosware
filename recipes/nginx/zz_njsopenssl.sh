rname="njsopenssl"
rver="$(cwver_njs)"
rdir="$(cwdir_njs)"
rfile="$(cwfile_njs)"
rdlfile="$(cwdlfile_njs)"
rurl="$(cwurl_njs)"
rsha256="$(cwsha256_njs)"
rreqs="openssl"

. "${cwrecipe}/nginx/njs.sh.common"

for f in clean fetch extract make ; do
  eval "function cw${f}_${rname}() {
    cw${f}_${rname%openssl}
  }"
done

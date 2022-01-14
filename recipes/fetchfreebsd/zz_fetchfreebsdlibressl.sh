rname="fetchfreebsdlibressl"
rver="$(cwver_fetchfreebsd)"
rdir="$(cwdir_fetchfreebsd)"
rfile="$(cwfile_fetchfreebsd)"
rdlfile="$(cwdlfile_fetchfreebsd)"
rurl="$(cwurl_fetchfreebsd)"
rsha256=""
rreqs="libressl"

. "${cwrecipe}/fetchfreebsd/fetchfreebsd.sh.common"

for f in fetch clean extract ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_fetchfreebsd
  }
  "
done

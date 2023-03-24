rname="wgetlibressl"
rver="$(cwver_wget)"
rdir="$(cwdir_wget)"
rfile="$(cwfile_wget)"
rurl="$(cwurl_wget)"
rsha256="$(cwsha256_wget)"

. "${cwrecipe}/${rname%libressl}/${rname%libressl}.sh.common"

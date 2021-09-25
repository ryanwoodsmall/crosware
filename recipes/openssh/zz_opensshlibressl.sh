rname="opensshlibressl"
rver="$(cwver_openssh)"
rdir="$(cwdir_openssh)"
rfile="$(cwfile_openssh)"
rdlfile="$(cwdlfile_openssh)"
rurl="$(cwurl_openssh)"
rsha256=""

sslprov="libressl"

. "${cwrecipe}/${rname%${sslprov}}/${rname%${sslprov}}.sh.common"

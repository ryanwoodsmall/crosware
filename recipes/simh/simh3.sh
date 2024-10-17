rname="simh3"
rver="v312-5"
rdir="${rname%3}_${rver}"
rfile="${rname%3}${rver}.zip"
rurl="http://simh.trailing-edge.com/sources/${rfile}"
rsha256="561524723b5979c4ba6d1ed58fd33749c47ac2934eba55d98c48f558b71f3ee8"

. "${cwrecipe}/simh/simh.sh.common"

eval "
function cwfetch_${rname}() {
  curl ${cwcurlopts} -I \"\$(cwurl_${rname})\" &>/dev/null || cwfailexit \"upstream url \$(cwurl_${rname}) appears to be gone\"
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
}
"

eval "
function cwextract_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  rm -rf sim \"\$(cwdir_${rname})\"
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  mv sim \"\$(cwdir_${rname})\"
  popd &>/dev/null
}
"

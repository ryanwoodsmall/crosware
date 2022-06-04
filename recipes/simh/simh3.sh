rname="simh3"
rver="v312-2"
rdir="${rname%3}_${rver}"
rfile="${rname%3}${rver}.zip"
rurl="http://simh.trailing-edge.com/sources/${rfile}"
rsha256="0f2b6e12c4749aee798e201d60bd1e9dd482525a34a44e988208238b3c6e8df2"

. "${cwrecipe}/simh/simh.sh.common"

eval "
function cwextract_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf sim \"\$(cwdir_${rname})\"
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  mv sim \"\$(cwdir_${rname})\"
  popd >/dev/null 2>&1
}
"

rname="nextvi"
rver="a458e47c0a1293b04da52c75ae7fb3dbbfab1b7c"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/kyx0r/nextvi/archive/${rfile}"
rsha256="2cb95b4e49f614a9c1d140d9b3b469ec0a8acee71161f2dbfd184252f1a43f05"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  bash ./build.sh
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  strip --strip-all vi
  install -m 0755 vi \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

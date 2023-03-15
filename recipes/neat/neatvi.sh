rname="neatvi"
rver="11"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/aligrudi/${rname}/archive/refs/tags/${rfile}"
rsha256="a87deb7e523de0a8e445b537e73d460c48929ba9386058ff27908b946b4c7782"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make CC=\"\${CC}\" LDFLAGS=-static
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

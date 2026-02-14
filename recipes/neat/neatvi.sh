rname="neatvi"
rver="18"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/aligrudi/neatvi/archive/refs/tags/${rfile}"
rsha256="a2f2b99a50a1ad24af5d51011ecebd78e5e4c83a8714237b542034478722657f"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make CC=\"\${CC}\" LDFLAGS='-s -static'
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  strip --strip-all vi
  install -m 0755 vi \"\$(cwidir_${rname})/bin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

rname="neatvi"
rver="20"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/aligrudi/neatvi/archive/refs/tags/${rfile}"
rsha256="e1d9a89d770aa5bb60da472be1a526eb1d99be9267c4d6067fc625f10efc8fe5"
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

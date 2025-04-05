rname="nextvi"
rver="07e9da9acfd5fbe48b2b35c9534032687d45aa67"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/kyx0r/nextvi/archive/${rfile}"
rsha256="94b741ccb1db9c3cd7a864d80175daeae7c74d94d0c0b3bc53b898ce1843b4b9"
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  bash ./build.sh
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

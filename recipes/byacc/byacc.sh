rname="byacc"
rver="20240109"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="f2897779017189f1a94757705ef6f6e15dc9208ef079eea7f28abec577e08446"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  rm -f \"\$(cwidir_${rname})/bin/{b,}yacc\"
  make install
  mv \"\$(cwidir_${rname})/bin/yacc\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf ${rname} \"\$(cwidir_${rname})/bin/yacc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

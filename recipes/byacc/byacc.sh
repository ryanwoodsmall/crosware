rname="byacc"
rver="20221106"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="a899be227bbcac9cf7700f7dbb5a8494688f1f9f0617b510762daeace47b9d12"
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

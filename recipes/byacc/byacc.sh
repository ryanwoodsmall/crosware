rname="byacc"
rver="20221229"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="1316c6f790fafa6688427f1ff91267b61d8b7873b443c620eef69a6eff0503bc"
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

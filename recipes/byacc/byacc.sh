rname="byacc"
rver="20260126"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="b618c5fb44c2f5f048843db90f7d1b24f78f47b07913c8c7ba8c942d3eb24b00"
rreqs="make diffutils"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  rm -f \"\$(cwidir_${rname})/bin/{b,}yacc\"
  make install
  mv \"\$(cwidir_${rname})/bin/yacc\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf ${rname} \"\$(cwidir_${rname})/bin/yacc\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

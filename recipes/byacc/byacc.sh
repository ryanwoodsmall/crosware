rname="byacc"
rver="20210619"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="acdd6080dcf935732a08ec8e8c4c161c666cd56d8c490739c6dbb6267a498c0e"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  rm -f \"${ridir}/bin/{b,}yacc\"
  make install
  mv \"${ridir}/bin/yacc\" \"${ridir}/bin/byacc\"
  ln -sf \"${rtdir}/current/bin/byacc\" \"${ridir}/bin/yacc\"
  popd >/dev/null 2>&1
}
"

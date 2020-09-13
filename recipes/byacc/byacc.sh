rname="byacc"
rver="20200910"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="0a5906073aeaf23ddc20aaac0ea61cb5ccc18572870b113375dec4ffe85ecf30"
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

rname="byacc"
rver="20210109"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="9e7d7768587141e7784492615dfefc70a8e00410043b63901efedc1b50c19b97"
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

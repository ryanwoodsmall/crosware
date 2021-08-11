rname="byacc"
rver="20210808"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="f158529be9d0594263c7f11a87616a49ea23e55ac63691252a2304fbbc7d3a83"
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

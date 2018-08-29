rname="byacc"
rver="20180609"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="5bbb0b3ec3da5981a2488383b652499d6c1e0236b47d8bac5fcdfa12954f749c"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make install
  mv "${ridir}/bin/yacc" "${ridir}/bin/byacc"
  ln -sf "${ridir}/bin/byacc" "${ridir}/bin/yacc"
  popd >/dev/null 2>&1
}
"

rname="byacc"
rver="20180510"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="d0940dbffbc7e9c9dd4985c25349c390beede84ae1d9fe86b71c0aa659a6d693"
rreqs="make m4 flex"

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

rname="byacc"
rver="20170709"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="27cf801985dc6082b8732522588a7b64377dd3df841d584ba6150bc86d78d9eb"
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

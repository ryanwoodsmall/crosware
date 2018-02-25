rname="byacc"
rver="20170709"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="27cf801985dc6082b8732522588a7b64377dd3df841d584ba6150bc86d78d9eb"
rprof="${cwetcprofd}/${rname}.sh"
rreqs="make m4 flex"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path "${cwsw}/${rname}/current/bin"' > "${rprof}"
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  make install
  mv "${cwsw}/${rname}/current/bin/yacc" "${cwsw}/${rname}/current/bin/byacc"
  ln -sf "${cwsw}/${rname}/current/bin/byacc" "${cwsw}/${rname}/current/bin/yacc"
  popd >/dev/null 2>&1
}
"

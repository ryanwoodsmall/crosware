rname="patchelf"
rver="0.18.0"
rdir="${rname}-${rver}"
rfile="${rname}-${rver}.tar.gz"
rurl="https://github.com/NixOS/${rname}/releases/download/${rver}/${rfile}"
rsha256="64de10e4c6b8b8379db7e87f58030f336ea747c0515f381132e810dbf84a86e7"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

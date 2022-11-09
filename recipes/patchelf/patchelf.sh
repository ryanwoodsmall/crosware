rname="patchelf"
rver="0.17.0"
rdir="${rname}-${rver}"
rfile="${rname}-${rver}.tar.gz"
rurl="https://github.com/NixOS/${rname}/releases/download/${rver}/${rfile}"
rsha256="eeda23de42bfcd6368615d00dc0700e595493fba6af5d98ed5d7d9d00a214abe"
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

#
# XXX - dir/file mismatch popped up in 0.11
# XXX - releases all over the place w/<=0.12?
#

rname="patchelf"
rver="0.14.3"
rdir="${rname}-${rver}"
rfile="${rname}-${rver}.tar.bz2"
#rurl="https://nixos.org/releases/${rname}/${rname}-${rver}/${rfile}"
rurl="https://github.com/NixOS/${rname}/releases/download/${rver}/${rfile}"
rsha256="a017ec3d2152a19fd969c0d87b3f8b43e32a66e4ffabdc8767a56062b9aec270"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

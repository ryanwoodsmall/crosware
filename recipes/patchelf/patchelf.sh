#
# XXX - dir/file mismatch popped up in 0.11
# XXX - releases all over the place w/<=0.12?
#

rname="patchelf"
rver="0.14"
rdir="${rname}-${rver}.19700101.dirty"
rfile="${rname}-${rver}.tar.bz2"
#rurl="https://nixos.org/releases/${rname}/${rname}-${rver}/${rfile}"
rurl="https://github.com/NixOS/${rname}/releases/download/${rver}/${rfile}"
rsha256="bfdf9d01d2b7d6209774a98df9902b6106d99929754623f815dbb86e995d37ef"
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

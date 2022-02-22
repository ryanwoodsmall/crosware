#
# XXX - dir/file mismatch popped up in 0.11
# XXX - releases all over the place w/<=0.12?
#

rname="patchelf"
rver="0.14.5"
rdir="${rname}-${rver}"
rfile="${rname}-${rver}.tar.bz2"
#rurl="https://nixos.org/releases/${rname}/${rname}-${rver}/${rfile}"
rurl="https://github.com/NixOS/${rname}/releases/download/${rver}/${rfile}"
rsha256="b9a46f2989322eb89fa4f6237e20836c57b455aa43a32545ea093b431d982f5c"
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

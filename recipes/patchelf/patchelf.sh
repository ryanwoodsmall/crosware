#
# XXX - dir/file mismatch popped up in 0.11
# XXX - releases all over the place w/<=0.12?
#

rname="patchelf"
rver="0.14.2"
rdir="${rname}-${rver}"
rfile="${rname}-${rver}.tar.bz2"
#rurl="https://nixos.org/releases/${rname}/${rname}-${rver}/${rfile}"
rurl="https://github.com/NixOS/${rname}/releases/download/${rver}/${rfile}"
rsha256="08bfea52ccf3e4e8b3dc5a6844bcecdde8e7d0a006160aec422d9af9c19e6079"
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

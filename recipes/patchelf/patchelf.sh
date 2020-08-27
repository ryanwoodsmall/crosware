#
# XXX - dir/file mismatch popped up in 0.11
# XXX - releases all over the place w/<=0.12?
#

rname="patchelf"
rver="0.12"
rdir="${rname}-${rver}.20200827.8d3a16e"
rfile="${rname}-${rver}.tar.bz2"
#rurl="https://nixos.org/releases/${rname}/${rname}-${rver}/${rfile}"
rurl="https://github.com/NixOS/${rname}/releases/download/${rver}/${rfile}"
rsha256="699a31cf52211cf5ad6e35a8801eb637bc7f3c43117140426400d67b7babd792"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

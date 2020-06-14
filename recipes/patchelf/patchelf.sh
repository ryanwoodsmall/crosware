#
# XXX - dir/file mismatch popped up in 0.11
#

rname="patchelf"
rver="0.11"
rdir="${rname}-${rver}.20200609.d6b2a72"
rfile="${rname}-${rver}.tar.bz2"
rurl="https://nixos.org/releases/${rname}/${rname}-${rver}/${rfile}"
rsha256="1d3221d87a2073c7d2fa0c5ee6aa53e2a808f7628832d3874468c1c8641cba9a"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

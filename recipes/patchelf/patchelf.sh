rname="patchelf"
rver="0.10"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://nixos.org/releases/${rname}/${rdir}/${rfile}"
rsha256="f670cd462ac7161588c28f45349bc20fb9bd842805e3f71387a320e7a9ddfcf3"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

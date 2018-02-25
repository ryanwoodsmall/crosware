rname="rlwrap"
rver="0.43"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/hanslub42/${rname}/releases/download/v${rver}/${rfile}"
rsha256="8e86d0b7882d9b8a73d229897a90edc207b1ae7fa0899dca8ee01c31a93feb2f"
rreqs="make readline"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

rname="cflow"
rver="1.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="d5392a6d8a63ba2f41df9f88b51f97bc0452c5262762a3c27e0412a6c03c06db"
rreqs="make sed"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

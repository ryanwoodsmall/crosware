rname="tig"
rver="2.5.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jonas/tig/releases/download/${rdir}/${rfile}"
rsha256="500d5d34524f6b856edd5cae01f1404d14f3b51a9a53fd7357f4cebb3d4c9e64"
rreqs="make ncurses readline git"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

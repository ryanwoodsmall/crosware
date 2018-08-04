rname="tig"
rver="2.4.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jonas/tig/releases/download/${rdir}/${rfile}"
rsha256="b6b6aa183e571224d0e1fab3ec482542c1a97fa7a85b26352dc31dbafe8558b8"
rreqs="make ncurses readline git"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

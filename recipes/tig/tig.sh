rname="tig"
rver="2.5.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jonas/tig/releases/download/${rdir}/${rfile}"
rsha256="c48284d30287a6365f8a4750eb0b122e78689a1aef8ce1d2961b6843ac246aa7"
rreqs="make ncurses readline git"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

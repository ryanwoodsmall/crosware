rname="tig"
rver="2.3.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jonas/tig/releases/download/${rdir}/${rfile}"
rsha256="d39d10c5a6db7b7663d51eff8ac2eaf075e319f5edabe09cb63a2b1b24846bea"
rreqs="make ncurses readline git"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

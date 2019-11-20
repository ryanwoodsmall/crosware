rname="tig"
rver="2.5.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jonas/tig/releases/download/${rdir}/${rfile}"
rsha256="ff537c67af9201e7e7276ce8a0ff9961e9d9c6a8a78790f5817124bd7755aef4"
rreqs="make ncurses readline git"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

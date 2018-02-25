rname="tmux"
rver="2.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rver}/${rfile}"
rsha256="b17cd170a94d7b58c0698752e1f4f263ab6dc47425230df7e53a6435cc7cd7e8"
rreqs="make libevent ncurses pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

rname="tmux"
rver="2.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rver}/${rfile}"
rsha256="9ded7d100313f6bc5a87404a4048b3745d61f2332f99ec1400a7c4ed9485d452"
rreqs="make libevent ncurses pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

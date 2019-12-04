#
# can be built with netbsdcurses:
#  CPPFLAGS=\"-I\${cwsw}/libevent/current/include -I\${cwsw}/netbsdcurses/current/include\"
#  LDFLAGS=\"-L\${cwsw}/libevent/current/lib -L\${cwsw}/netbsdcurses/current/lib -static\"
#  LIBS=\"-lcurses -lterminfo\"
#

rname="tmux"
rver="3.0a"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rver}/${rfile}"
rsha256="4ad1df28b4afa969e59c08061b45082fdc49ff512f30fc8e43217d7b0e5f8db9"
rreqs="make libevent ncurses pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

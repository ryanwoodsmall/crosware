#
# can be built with netbsdcurses:
#  CPPFLAGS=\"-I\${cwsw}/libevent/current/include -I\${cwsw}/netbsdcurses/current/include\"
#  LDFLAGS=\"-L\${cwsw}/libevent/current/lib -L\${cwsw}/netbsdcurses/current/lib -static\"
#  LIBS=\"-lcurses -lterminfo\"
#

rname="tmux"
rver="3.1b"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rver}/${rfile}"
rsha256="d93f351d50af05a75fe6681085670c786d9504a5da2608e481c47cf5e1486db9"
rreqs="make libevent ncurses pkgconfig byacc"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

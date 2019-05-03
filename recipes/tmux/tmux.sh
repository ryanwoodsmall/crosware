#
# can be built with netbsdcurses:
#  CPPFLAGS=\"-I\${cwsw}/libevent/current/include -I\${cwsw}/netbsdcurses/current/include\"
#  LDFLAGS=\"-L\${cwsw}/libevent/current/lib -L\${cwsw}/netbsdcurses/current/lib -static\"
#  LIBS=\"-lcurses -lterminfo\"
#

rname="tmux"
rver="2.9"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rver}/${rfile}"
rsha256="34901232f486fd99f3a39e864575e658b5d49f43289ccc6ee57c365f2e2c2980"
rreqs="make libevent ncurses pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

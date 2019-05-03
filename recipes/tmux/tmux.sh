#
# can be built with netbsdcurses:
#  CPPFLAGS=\"-I\${cwsw}/libevent/current/include -I\${cwsw}/netbsdcurses/current/include\"
#  LDFLAGS=\"-L\${cwsw}/libevent/current/lib -L\${cwsw}/netbsdcurses/current/lib -static\"
#  LIBS=\"-lcurses -lterminfo\"
#

rname="tmux"
rver="2.9a"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rver}/${rfile}"
rsha256="839d167a4517a6bffa6b6074e89a9a8630547b2dea2086f1fad15af12ab23b25"
rreqs="make libevent ncurses pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

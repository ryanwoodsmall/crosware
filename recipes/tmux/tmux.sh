#
# can be built with netbsdcurses:
#  CPPFLAGS=\"-I\${cwsw}/libevent/current/include -I\${cwsw}/netbsdcurses/current/include\"
#  LDFLAGS=\"-L\${cwsw}/libevent/current/lib -L\${cwsw}/netbsdcurses/current/lib -static\"
#  LIBS=\"-lcurses -lterminfo\"
#

rname="tmux"
rver="3.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rver}/${rfile}"
rsha256="979bf38db2c36193de49149aaea5c540d18e01ccc27cf76e2aff5606bd186722"
rreqs="make libevent ncurses pkgconfig bsdheaders"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"\${CPPFLAGS} -I${cwsw}/bsdheaders/current\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

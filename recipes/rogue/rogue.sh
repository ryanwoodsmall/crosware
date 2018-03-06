rname="rogue"
rver="5.4.5"
rdir="${rname}${rver}"
rfile="${rdir}a-src.tar.gz"
rurl="http://rogue.rogueforge.net/files/rogue5.4/${rfile}"
rsha256="6d38e38f95a291e7854162227e7d2de28b51dfbda761707a190c2d7f629cf4a6"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --enable-wizardmode \
    --enable-scorefile=${rtdir}/rogue.scr \
    --enable-lockfile=${rtdir}/rogue.lck
  echo '#include <sys/types.h>' >> config.h
  echo '#define NCURSES_INTERNALS 1' >> config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

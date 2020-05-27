#
# XXX - update to 1.7.5? dl doesn't seem to work
#
rname="brogue"
rver="1.7.4"
rdir="${rname}-${rver}"
rfile="${rdir}-linux-i386.tbz2"
rurl="https://sites.google.com/site/broguegame/${rfile}\?attredirects=0\&d=1"
rsha256="9e313521c4004566ab1518402393f5bd1cc14df097a283c2cc614998b9097e26"
rreqs="make ncurses rsync"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cat Makefile > Makefile.ORIG
  sed -i 's/-march=i586//g' Makefile
  sed -i \"/^CURSES_DEF/ s# = # = -I${cwsw}/ncurses/current/include -I${cwsw}/ncurses/current/include/ncurses #g\" Makefile
  sed -i \"/^CURSES_LIB/ s# = # = -L${cwsw}/ncurses/current/lib -static #g\" Makefile
  sed -i \"/^SDL_FLAGS/d\" Makefile
  sed -i \"s/^CFLAGS=/CFLAGS=-Wl,-static /g\" Makefile
  sed -i \"/^LASTTARGET/s/.*/LASTTARGET=curses/g\" Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  rm -f bin/brogue
  make curses
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cwmkdir "${ridir}"
  find . -maxdepth 1 ! -type d -exec chmod a-x {} +
  chmod 755 brogue
  rsync -avHS ${rbdir}/. ${ridir}/.
  rm -rf ${ridir}/bin/*.so*
  rm -f ${ridir}/src/libtcod*/{samples_c{,pp},hmtool}{,_debug}
  find ${ridir}/ -type f -name '*.o' -print | xargs rm -f
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current\"' > \"${rprof}\"
  echo 'alias brogue=\"env TERM=tmux-256color ${rtdir}/current/${rname} -t\"' >> \"${rprof}\"
}
"

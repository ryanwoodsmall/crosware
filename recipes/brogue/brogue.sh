#
# XXX - sites.google sucks
# XXX - move to arch brogue-ce?
# XXX - netbsdcurses...
# XXX - could easily replace rsync with '( cd $rbdir ; tar -cf - . ) | ( cd $ridir ; tar -xf - )'
#
# https://aur.archlinux.org/packages/brogue/?comments=all
# https://aur.archlinux.org/packages/brogue/?setlang=nb&comments=all&O=10&PP=10
#

rname="brogue"
rver="1.7.5"
rdir="${rname}-${rver}"
rfile="${rdir}-linux-amd64.tbz2"
#rurl="https://sites.google.com/site/broguegame/${rfile}?attredirects=0&d=1"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="a74ff18139564c597d047cfb167f74ab1963dd8608b6fb2e034e7635d6170444"
rreqs="make ncurses"

if ! command -v rsync &>/dev/null ; then
  rreqs="${rreqs} rsyncminimal"
fi

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" &>/dev/null
  cat Makefile > Makefile.ORIG
  sed -i 's/-march=i586//g' Makefile
  sed -i \"/^CURSES_DEF/ s# = # = -I${cwsw}/ncurses/current/include -I${cwsw}/ncurses/current/include/ncurses #g\" Makefile
  sed -i \"/^CURSES_LIB/ s# = # = -L${cwsw}/ncurses/current/lib -static #g\" Makefile
  sed -i \"/^SDL_FLAGS/d\" Makefile
  sed -i \"s/^CFLAGS=/CFLAGS=-Wl,-static /g\" Makefile
  sed -i \"/^LASTTARGET/s/.*/LASTTARGET=curses/g\" Makefile
  cat src/brogue/Rogue.h > src/brogue/Rogue.h.ORIG
  echo '#include <stdint.h>' > src/brogue/Rogue.h
  cat src/brogue/Rogue.h.ORIG >> src/brogue/Rogue.h
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" &>/dev/null
  rm -f bin/brogue
  make curses
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" &>/dev/null
  cwmkdir "${ridir}"
  find . -maxdepth 1 ! -type d -exec chmod a-x {} +
  chmod 755 brogue
  rsync -avHS ${rbdir}/. ${ridir}/.
  rm -rf ${ridir}/bin/*.so*
  rm -f ${ridir}/src/libtcod*/{samples_c{,pp},hmtool}{,_debug}
  find ${ridir}/ -type f -name '*.o' -print | xargs rm -f
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current\"' > \"${rprof}\"
  echo 'alias brogue=\"env TERM=tmux-256color ${rtdir}/current/${rname} -t\"' >> \"${rprof}\"
}
"

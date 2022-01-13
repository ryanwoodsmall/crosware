rname="tignetbsdcurses"
rver="$(cwver_tig)"
rdir="$(cwdir_tig)"
rfile="$(cwfile_tig)"
rdlfile="$(cwdlfile_tig)"
rurl="$(cwurl_tig)"
rsha256=""
rreqs="make netbsdcurses pkgconfig"

. "${cwrecipe}/common.sh"

for f in fetch clean extract ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_tig
  }
  "
done
unset f

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat configure > configure.ORIG
  sed -i s/ncurses/curses/g configure || true
  sed -i s/NCURSES/CURSES/g configure || true
  grep -rl 'warn(' . | xargs sed -i.ORIG 's/warn(/tigwarn(/g'
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
    LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -static\" \
    LIBS=\"-lreadline -lcurses -lterminfo\" \
    CURSES_CFLAGS=\"-I${cwsw}/netbsdcurses/current/include -L${cwsw}/netbsdcurses/current/lib\" \
    CURSES_LIBS='-lreadline -lcurses -lterminfo' \
    PKG_CONFIG_{PATH,LIBDIR}=\"${cwsw}/netbsdcurses/current/lib/pkgconfig\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

rname="tignetbsdcurses"
rver="$(cwver_tig)"
rdir="$(cwdir_tig)"
rfile="$(cwfile_tig)"
rdlfile="$(cwdlfile_tig)"
rurl="$(cwurl_tig)"
rsha256=""
rreqs="make netbsdcurses pkgconfig pcre2"

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
    --with-pcre \
      CPPFLAGS=\"\$(echo -I${cwsw}/{netbsdcurses,pcre2}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{netbsdcurses,pcre2}/current/lib) -static\" \
      LIBS=\"-lreadline -lcurses -lterminfo\" \
      CURSES_CFLAGS=\"-I${cwsw}/netbsdcurses/current/include -L${cwsw}/netbsdcurses/current/lib\" \
      CURSES_LIBS='-lreadline -lcurses -lterminfo' \
      PKG_CONFIG_{PATH,LIBDIR}=\"\$(echo ${cwsw}/{netbsdcurses,pcre2}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install
  ln -sf tig \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

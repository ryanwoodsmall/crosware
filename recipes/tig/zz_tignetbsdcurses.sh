rname="tignetbsdcurses"
rver="$(cwver_tig)"
rdir="$(cwdir_tig)"
rfile="$(cwfile_tig)"
rdlfile="$(cwdlfile_tig)"
rurl="$(cwurl_tig)"
rsha256=""
rreqs="make netbsdcurses readlinenetbsdcurses pkgconfig pcre2"

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
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cat configure > configure.ORIG
  sed -i s/ncurses/curses/g configure || true
  sed -i s/NCURSES/CURSES/g configure || true
  grep -rl 'warn(' . | xargs sed -i.ORIG 's/warn(/tigwarn(/g'
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --with-pcre \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      LIBS=\"-lreadline -lcurses -lterminfo\" \
      CURSES_CFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include -L${cwsw}/{${rreqs// /,}/current/lib)\" \
      CURSES_LIBS='-lreadline -lcurses -lterminfo' \
      PKG_CONFIG_{PATH,LIBDIR}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  ln -sf tig \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

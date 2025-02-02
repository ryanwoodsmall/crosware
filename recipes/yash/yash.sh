#
# XXX - minimal termcap variant? doesn't seem to work, looking for tinfo/terminfo/curses/ncurses{,w}
#
rname="yash"
rver="2.58"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/magicant/${rname}/releases/download/${rver}/${rfile}"
rsha256="4c7367998ad8fea0ea9dc787985925c3fff11853196bfbe931627ad5ee265cc5"
rreqs="make netbsdcurses libeditnetbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-nls \
    --enable-{array,dirstack,double-bracket,help,history,lineedit,printf,socket,test,ulimit} \
    --with-term-lib='edit curses terminfo' \
      CC=\"\${CC} \${CFLAGS} \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) \$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=-static \
      LIBS='-ledit -lcurses -lterminfo -static' \
      CPPFLAGS=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

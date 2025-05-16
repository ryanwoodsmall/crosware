#
# XXX - minimal termcap variant? doesn't seem to work, looking for tinfo/terminfo/curses/ncurses{,w}
#
rname="yash"
rver="2.59"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/magicant/yash/releases/download/${rver}/${rfile}"
rsha256="9be969da808bc079ebc9cc29c8f7cd9fdbefbfb29ff4a636b7b25294ea45086a"
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

rname="yash"
rver="2.50"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/magicant/${rname}/releases/download/${rver}/${rfile}"
rsha256="b6e0e2e607ab449947178da227fa739db4b13c8af9dfe8116b834964b980e24b"
rreqs="make netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-nls \
    --enable-{array,dirstack,double-bracket,help,history,lineedit,printf,socket,test,ulimit} \
    --with-term-lib='edit curses terminfo' \
      CC=\"\${CC} \${CFLAGS} -L${cwsw}/netbsdcurses/current/lib -I${cwsw}/netbsdcurses/current/include\" \
      LDFLAGS=\"-static\" \
      LIBS='-ledit -lcurses -lterminfo -static' \
      CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

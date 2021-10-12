rname="yash"
rver="2.52"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/magicant/${rname}/releases/download/${rver}/${rfile}"
rsha256="55137beffd83848805b8cef90c0c6af540744afcc103e1b0f7bdf3ef1991b5c9"
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

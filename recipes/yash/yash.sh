rname="yash"
rver="2.51"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/magicant/${rname}/releases/download/${rver}/${rfile}"
rsha256="6f15e68eeb63fd42e91c3ce75eccf325f2c938fa1dc248e7213af37c043aeaf8"
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

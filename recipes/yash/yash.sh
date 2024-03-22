#
# XXX - minimal termcap variant? doesn't seem to work, looking for tinfo/terminfo/curses/ncurses{,w}
#
rname="yash"
rver="2.56.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/magicant/${rname}/releases/download/${rver}/${rfile}"
rsha256="03e3f8dd10f8cdab9a9799e7b97d07f1eb58bbbad2fd6ac112a399aace026b0e"
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

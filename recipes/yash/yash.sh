#
# XXX - minimal termcap variant? doesn't seem to work, looking for tinfo/terminfo/curses/ncurses{,w}
#
rname="yash"
rver="2.60"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/magicant/yash/releases/download/${rver}/${rfile}"
rsha256="f5310a0315db4bb9e3d86c2e8c22b6a6e0d01cbc88c6530e44af252ba10b6158"
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

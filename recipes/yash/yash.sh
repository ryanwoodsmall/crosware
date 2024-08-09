#
# XXX - minimal termcap variant? doesn't seem to work, looking for tinfo/terminfo/curses/ncurses{,w}
#
rname="yash"
rver="2.57"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/magicant/${rname}/releases/download/${rver}/${rfile}"
rsha256="6e0afb767d7d7378713c4b9fdcf2cdca4871d5b11ebae07f5646aea8182aa03e"
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

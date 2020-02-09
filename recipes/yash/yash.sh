#
# XXX - use github mirror? https://github.com/magicant/yash/releases
#

rname="yash"
rver="2.49"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://osdn.net/dl/${rname}/${rfile}"
rsha256="66eaf11d6c749165a7503801691759ae151e4eae00785875e121db2e9c219c72"
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

rname="exvi"
rreqs="make netbsdcurses"

. "${cwrecipe}/heirloom/heirloom.sh.common"
. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}/heirloom-ex-vi\" >/dev/null 2>&1
  sed -i.ORIG \"/^PREFIX.*=/s#^PREFIX.*#PREFIX = ${ridir}#g\" Makefile
  sed -i '/^TERMLIB.*=/s/ncurses/curses/g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}/heirloom-ex-vi\" >/dev/null 2>&1
  make CPPFLAGS=\"-I${cwsw}/netbsdcurses/include\" LDADD=\"-L${cwsw}/netbsdcurses/current/lib -lcurses -lterminfo -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}/heirloom-ex-vi\" >/dev/null 2>&1
  make install
  for l in edit vedit view vi ; do
    ln -sf \"${rtdir}/current/bin/ex\" \"${ridir}/bin/\${l}\"
  done
  ln -sf \"${rtdir}/current/bin/vi\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/vi\" \"${ridir}/bin/ex-vi\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

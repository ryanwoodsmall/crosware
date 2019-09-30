rname="exvi"
rver="20190920-musl"
rdir="heirloom-project-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/ryanwoodsmall/heirloom-project/archive/${rfile}"
rsha256="99d24df8fe99bf26a45f658aca10da19804175c66a4a6dec77bbf789319f0bb5"
rreqs="make netbsdcurses"
rprof="${cwetcprofd}/zz_${rname}.sh"

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
  make CPPFLAGS=\"-I${cwsw}/netbsdcurses/include\"  LDADD=\"-L${cwsw}/netbsdcurses/current/lib -lcurses -lterminfo -static\"
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

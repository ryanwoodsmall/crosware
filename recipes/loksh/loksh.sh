rname="loksh"
rver="6.6"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/dimkr/${rname}/archive/${rfile}"
rsha256="97a020df82ceebe216c5a306e87360c5e3398d7403347aaff50978446ccb764d"
rreqs="make netbsdcurses pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i 's/ncurses/curses terminfo/g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env \
    CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
    LDFLAGS=\"-static -L${cwsw}/netbsdcurses/current/lib\" \
    PKG_CONFIG_PATH=\"${cwsw}/netbsdcurses/current/lib/pkgconfig\" \
    PKG_CONFIG_LIBDIR=\"${cwsw}/netbsdcurses/current/lib/pkgconfig\" \
    PREFIX=\"${ridir}\" \
      make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  find ${ridir}/bin/ ! -type d | grep 'sh$' | xargs rm -f
  make install PREFIX=\"${ridir}\"
  mv \"${ridir}/bin/ksh\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/ksh\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/sh\"
  find \"${ridir}/bin/\" -type f | xargs \$(\${CC} -dumpmachine)-strip --strip-all
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

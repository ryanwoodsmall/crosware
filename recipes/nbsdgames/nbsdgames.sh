rname="nbsdgames"
rver="6.0.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/abakh/${rname}/archive/refs/tags/${rfile}"
rsha256="7bbb45c9b65b5f7849582f06feff4d60e31cde13da9db7f344ca2eb69802491f"
rreqs="make netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  cat Makefile > Makefile.ORIG
  sed -i '/^GAMES_DIR/s,^.*,GAMES_DIR=${ridir}/bin,g' Makefile
  sed -i '/^SCORES_DIR/s,^.*,SCORES_DIR=${ridir}/scores,g' Makefile
  sed -i '/^MAN_DIR/s,^.*,MAN_DIR=${ridir}/man/man6,g' Makefile
  sed -i '/^LDFLAGS/s,^.*,LDFLAGS=-L${cwsw}/netbsdcurses/current/lib -lcurses -lterminfo -static,g' Makefile
  sed -i '/^CFLAGS/s,= ,= -I${cwsw}/netbsdcurses/current/include ,g' Makefile
  sed -i '/^LIBS_PKG_CONFIG/s,^.*,LIBS_PKG_CONFIG=-lcurses -lterminfo -static,g' Makefile
  grep -rl -- -lncurses . | grep -v ORIG$ | xargs sed -i 's,-lncurses,-lcurses -lterminfo,g'
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  (
    unset PKG_CONFIG_{LIBDIR,PATH}
    export CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\"
    export LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -lcurses -lterminfo -static\"
    make -j${cwmakejobs} ${rlibtool}
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/scores\"
  cwmkdir \"${ridir}/man/man6\"
  make install
  make manpages
  \$(\${CC} -dumpmachine)-strip --strip-all ${ridir}/bin/* || true
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

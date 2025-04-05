rname="nbsdgames"
rver="5"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/abakh/${rname}/archive/refs/tags/${rfile}"
rsha256="ca81d8b854a7bf9685bbc58aabc1a24cd617cadb7e9ddac64a513d2c8ddb2e6c"
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
  sed -i '/^CFLAGS/s,= ,= -I${cwsw}/netbsdcurses/current/include ,' Makefile
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

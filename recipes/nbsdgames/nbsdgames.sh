rname="nbsdgames"
rver="6.0.2"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/abakh/nbsdgames/archive/refs/tags/${rfile}"
rsha256="9545b099f6edb2be08d8885eaae2e10cf3d114c3a8fa1fc3eefff156053f37ca"
rreqs="make netbsdcurses"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat src/Makefile > src/Makefile.ORIG
  sed -i \"/^GAMES_DIR/s,^.*,GAMES_DIR=\$(cwidir_${rname})/bin,g\" src/Makefile
  sed -i \"/^SCORES_DIR/s,^.*,SCORES_DIR=\$(cwidir_${rname})/scores,g\" src/Makefile
  sed -i \"/^MAN_DIR/s,^.*,MAN_DIR=\$(cwidir_${rname})/man/man6,g\" src/Makefile
  sed -i \"/^LDFLAGS/s,^.*,LDFLAGS=-L${cwsw}/netbsdcurses/current/lib -lcurses -lterminfo -static,g\" src/Makefile
  sed -i \"/^CFLAGS/s|= |= -I${cwsw}/netbsdcurses/current/include -Wl,-L${cwsw}/netbsdcurses/current/lib |g\" src/Makefile
  sed -i \"/^LIBS_PKG_CONFIG/s,^.*,LIBS_PKG_CONFIG=-L${cwsw}/netbsdcurses/current/lib -lcurses -lterminfo -static,g\" src/Makefile
  grep -rl -- '-lcurses -lterminfo' . | grep -v ORIG$ | xargs sed -i 's,-lcurses -lterminfo,-lcurses -lterminfo,g'
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/scores\"
  cwmkdir \"\$(cwidir_${rname})/man/man6\"
  make install
  make manpages
  \$(\${CC} -dumpmachine)-strip --strip-all \$(cwidir_${rname})/bin/* || true
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

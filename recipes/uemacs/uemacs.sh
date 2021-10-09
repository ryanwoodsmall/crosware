rname="uemacs"
rver="1cdcf9df88144049750116e36fe20c8c39fa2517"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="2a5c1fc38dbea29c9527e011f7c63815f01a41123a31bed2e05910d3e16e768f"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} \
    V=1 \
    BINDIR=\"${ridir}/bin\" \
    LIBDIR=\"${ridir}/lib\" \
    CC=\"\${CC} \${CFLAGS} \$(echo -I${cwsw}/ncurses/current/include{,/ncurses}) -L${cwsw}/ncurses/current/lib\" \
    LIBS='-lncurses -static -s'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/lib\"
  make install \
    V=1 \
    BINDIR=\"${ridir}/bin\" \
    LIBDIR=\"${ridir}/lib\"
  ln -sf em \"${ridir}/bin/${rname}\"
  ln -sf em \"${ridir}/bin/microemacs\"
  ln -sf em \"${ridir}/bin/micro-emacs\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

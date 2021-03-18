rname="dvtm"
rver="0.15"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/martanne/${rname}/releases/download/v${rver}/${rfile}"
rsha256="8f2015c05e2ad82f12ae4cf12b363d34f527a4bbc8c369667f239e4542e1e510"
rreqs="make abduco ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/^PREFIX/s,^PREFIX.*,PREFIX=${ridir},g' config.mk
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/ncurses/current/bin:\${PATH}\" \
    make \
      CC=\"\${CC} -I${cwsw}/ncurses/current/include -I${cwsw}/ncurses/current/include/ncursesw -L${cwsw}/ncurses/current/lib\" \
      LDFLAGS=\"-L${cwsw}/ncurses/current/lib -lncursesw -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/ncurses/current/bin:\${PATH}\" \
    make \
      install \
      CC=\"\${CC} -I${cwsw}/ncurses/current/include -I${cwsw}/ncurses/current/include/ncursesw -L${cwsw}/ncurses/current/lib\" \
      LDFLAGS=\"-L${cwsw}/ncurses/current/lib -lncursesw -static\"
  cwmkdir \"${ridir}/share/terminfo\"
  install -m 0644 ${rname}.info \"${ridir}/share/terminfo/${rname}.info\"
  \"${cwsw}/ncurses/current/bin/tic\" -s -x ${rname}.info
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

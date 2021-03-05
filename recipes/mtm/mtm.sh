#
# XXX - need second tic invocation with `env TERMINFO=${HOME}/.terminfo ...` set?
#

rname="mtm"
rver="1.2.0"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/deadpixi/${rname}/archive/${rfile}"
rsha256="68f753f743fcd3d87f269011d4bbd3fed59cfcad710d7c7db98844e3e675c196"
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
  make \
    CC=\"\${CC}\" \
    CFLAGS=\"\${CFLAGS} \${CPPFLAGS}\" \
    DESTDIR=\"${ridir}\" \
    LIBS=\"\${LDFLAGS} -lncursesw -lutil -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/man/man1\"
  cwmkdir \"${ridir}/share/terminfo\"
  make install DESTDIR=\"${ridir}\"
  install -m 0644 ${rname}.ti \"${ridir}/share/terminfo/${rname}.ti\"
  \"${cwsw}/ncurses/current/bin/tic\" -s -x ${rname}.ti
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

rname="elvis"
rver="2.2_1-pre3"
rdir="${rname}-${rver}"
#rfile="${rdir}.tar.gz"
#rurl="https://github.com/mbert/${rname}/releases/download/v${rver}/${rfile}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/mbert/elvis/archive/refs/tags/v2.2_1-pre3.tar.gz"
rsha256="59a0c561de4dfef40a46162c82dc68c48ac633674250746e0e3a9ffc9cc0878d"
rreqs="make netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG \"/^PREFIX=/s#PREFIX=.*#PREFIX=${ridir}#g\" configure instman.sh Makefile.in
  sed -i 's/TLIBS=\"-lcurses\"/TLIBS=\"-lcurses -lterminfo -static\"/g' configure
  sed -i '/^\\t.*CC/s/EXE)\$/EXE) -static/g' Makefile.in
  sed -i '/^ALL=/s/\$/ ctags/' Makefile.in
  sed -i \"s#/etc/${rname}#${ridir}/etc/${rname}#g\" Makefile.in configure
  sed -i \"s#/usr/include/termcap.h#${cwsw}/netbsdcurses/current/include/termcap.h#g\" configure
  sed -i \"s#/usr/include#${cwsw}/statictoolchain/current/\$(\${CC} -dumpmachine)/include#g\" configure
  sed -i \"s#/usr/local/share/man#${ridir}/share/man#g\" instman.sh
  rm -rf \"${ridir}/share/man\"
  mkdir -p \"${ridir}/etc/${rname}\" \"${ridir}/share/man/man1\" \"${ridir}/share/man/catman1\"
  ln -sf ${ridir}/share/man/man{,.}1
  ln -sf ${ridir}/share/man/catman{,.}1
  ln -sf \"${ridir}/share/man\" \"${ridir}/share/MAN\"
  env CPPFLAGS= LDFLAGS= MANPATH=\"${ridir}/share/man\" \
    ./configure ${cwconfigureprefix} \
      --verbose \
      --x-includes=\"${cwsw}/statictoolchain/current/\$(\${CC} -dumpmachine)/include\" \
      --ioctl=termios \
      --without-{x{,ft},gnome} \
        linux
  sed -i.ORIG '/PROTOCOL_/s/undef/define/g' config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make \
    CC=\"\${CC} \${CFLAGS} -fcommon -I${cwsw}/netbsdcurses/current/include -L${cwsw}/netbsdcurses/current/lib\" \
    CPPFLAGS= \
    LDFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install MANPATH=\"${ridir}/share/man\"
  popd >/dev/null 2>&1
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rbdir}\"
  rm -rf \"._${rdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'alias elvis=\"env TERM=xterm elvis\"' >> \"${rprof}\"
}
"

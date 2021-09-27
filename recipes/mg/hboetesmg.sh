#
# XXX - ncurses variant
#

rname="hboetesmg"
rver="20210609"
rdir="${rname#hboetes}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/${rname%mg}/${rname#hboetes}/archive/refs/tags/${rfile}"
rsha256="8ecb0599a42c2bce473095847bbc4ff45812ea87a02490798323ab8f03c6f2bc"
rreqs="make netbsdcurses pkgconfig libbsd"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local p=\"${cwsw}/pkgconfig/current/bin/pkg-config\"
  cat GNUmakefile > GNUmakefile.ORIG
  sed -i '/CURSES_LIBS:=/s|=.*|=-L${cwsw}/netbsdcurses/current/lib -lcurses -lterminfo -static|g' GNUmakefile
  sed -i \"/BSD_CPPFLAGS:=/s|=.*|=\$(\${p} --cflags libbsd-overlay) -DHAVE_PTY_H|g\" GNUmakefile
  sed -i \"/BSD_LIBS:=/s|=.*|=\$(\${p} --libs libbsd-overlay) -lutil -static|g\" GNUmakefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  true
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local p=\"${cwsw}/pkgconfig/current/bin/pkg-config\"
  local m='mg'
  local n=\"${rname%mg}\"
  local f=\"${rtdir}/current/bin/mg\"
  make -f GNUmakefile \
    clean \
    install-strip \
      prefix=\"${ridir}\" \
      CC=\"\${CC} -I${cwsw}/netbsdcurses/current/include \$(\${p} --cflags libbsd-overlay) -DHAVE_PTY_H\" \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
      INSTALL=install \
      LDFLAGS=\"-static\" \
      PKG_CONFIG=\"\${p}\" \
      STATIC=yesplease \
      STRIP=\"\$(\${CC} -dumpmachine)-strip\"
  ln -sf \"\${f}\" \"${ridir}/bin/${rname}\"
  ln -sf \"\${f}\" \"${ridir}/bin/\${m}-\${n}\"
  ln -sf \"\${f}\" \"${ridir}/bin/\${n}-\${m}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/mg/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"

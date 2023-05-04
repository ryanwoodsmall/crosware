#
# XXX - ncurses variant
#

rname="hboetesmg"
rver="20230501"
rdir="${rname#hboetes}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/${rname%mg}/${rname#hboetes}/archive/refs/tags/${rfile}"
rsha256="e2878feca64067a0c524e456ffba68d8cb69bcdce0943d2f2b69cad06174462e"
rreqs="make netbsdcurses pkgconfig libbsd"

. "${cwrecipe}/common.sh"

cwstubfunc "cwmake_${rname}"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local p=\"${cwsw}/pkgconfig/current/bin/pkg-config\"
  cat GNUmakefile > GNUmakefile.ORIG
  sed -i '/CURSES_LIBS:=/s|=.*|=-L${cwsw}/netbsdcurses/current/lib -lcurses -lterminfo -static|g' GNUmakefile
  sed -i \"/BSD_CPPFLAGS:=/s|=.*|=\$(\${p} --cflags libbsd-overlay) -DHAVE_PTY_H|g\" GNUmakefile
  sed -i \"/BSD_LIBS:=/s|=.*|=\$(\${p} --libs libbsd-overlay) -lutil -static|g\" GNUmakefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local p=\"${cwsw}/pkgconfig/current/bin/pkg-config\"
  local m='mg'
  local n=\"${rname%mg}\"
  local f=\"${rtdir}/current/bin/mg\"
  make -f GNUmakefile \
    clean \
    install-strip \
      prefix=\"\$(cwidir_${rname})\" \
      CC=\"\${CC} -I${cwsw}/netbsdcurses/current/include \$(\${p} --cflags libbsd-overlay) -DHAVE_PTY_H\" \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
      INSTALL=install \
      LDFLAGS=\"-static\" \
      PKG_CONFIG=\"\${p}\" \
      STATIC=yesplease \
      STRIP=\"\$(\${CC} -dumpmachine)-strip\"
  ln -sf \"\${f}\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"\${f}\" \"\$(cwidir_${rname})/bin/\${m}-\${n}\"
  ln -sf \"\${f}\" \"\$(cwidir_${rname})/bin/\${n}-\${m}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/mg/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"

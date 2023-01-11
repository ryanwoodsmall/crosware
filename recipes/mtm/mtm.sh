#
# XXX - UGH TERMINFO TERMCAP TERMINALS $TERM UGH
# XXX - ugh, just use xterm-color for now!
# XXX - disable -bce (back_color_erase) since old rhel<=7 don't seem to have it?
# XXX - netbsdcurses needs /usr/share/misc/terminfo fix, then something like...
#   test -e \"${cwsw}/netbsdcurses/current/bin/tic\" && \"${cwsw}/netbsdcurses/current/bin/tic\" -s -x ${rname}.ti || true
# XXX - or just include mtm.ti in netbsdcurses?
# XXX - set default terms to mtm/mtm-256color?
#

rname="mtm"
rver="1.2.1"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/deadpixi/${rname}/archive/${rfile}"
rsha256="2ae05466ef44efa7ddb4bce58efc425617583d9196b72e80ec1090bd77df598c"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

#eval "
#function cwconfigure_${rname}() {
#  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
#  cat config.def.h > config.def.h.ORIG
#  sed -i 's,screen-256color-bce,xterm-color,g' config.def.h
#  sed -i 's,screen-bce,xterm-color,g' config.def.h
#  popd >/dev/null 2>&1
#}
#"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make \
    CC=\"\${CC}\" \
    CFLAGS=\"\${CFLAGS} \${CPPFLAGS}\" \
    DESTDIR=\"\$(cwidir_${rname})\" \
    LIBS=\"\${LDFLAGS} -lncursesw -lutil -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  cwmkdir \"\$(cwidir_${rname})/share/terminfo\"
  make install DESTDIR=\"\$(cwidir_${rname})\"
  install -m 0644 ${rname}.ti \"\$(cwidir_${rname})/share/terminfo/${rname}.ti\"
  env TERMINFO=\"${cwsw}/ncurses/current/share/terminfo\" \"${cwsw}/ncurses/current/bin/tic\" -s -x ${rname}.ti || true
  cwmkdir \"\${HOME}/.terminfo\"
  env TERMINFO=\"\${HOME}/.terminfo\" \"${cwsw}/ncurses/current/bin/tic\" -s -x ${rname}.ti || true
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

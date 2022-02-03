rname="tetrisbsd"
rver="2.0"
rdir="tetris-bsd-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/sirjofri/tetris-bsd/archive/refs/tags/${rfile}"
rsha256="7ed0db25bb1faeef72174bffcd48f9473ad6d4d0325fdd0434c150f171107d64"
rreqs="make libbsd netbsdcurses pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  grep -rl sys/poll . | xargs sed -i.ORIG s,sys/poll,poll,g || true
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -e 's%@tetris_scorefile@%${ridir}/scores/${rname}.scores%g' tetris.6.in > tetris.6
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  for c in *.c ; do
    echo \${c}
    \${CC} \${CFLAGS} \
      -D_GNU_SOURCE \
      -D_PATH_SCOREFILE='\"${ridir}/scores/${rname}.scores\"' \
      \$(pkg-config --cflags libbsd-overlay) \
      -I${cwsw}/netbsdcurses/current/include \
        -c \${c} -o \${c//.c/.o} 2>&1 | sed \"s,^,\${c}:,g\"
  done
  unset c
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \${CC} \${CFLAGS} \
    -D_GNU_SOURCE \
    -D_PATH_SCOREFILE='\"${ridir}/scores/${rname}.scores\"' \
      *.o -o tetris2 \
        \$(pkg-config --libs libbsd-overlay) \
        -L${cwsw}/netbsdcurses/current/lib \
          -lbsd -lcurses -lterminfo -static -Wl,-s
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man6\"
  cwmkdir \"${ridir}/scores\"
  install -m 755 tetris2 \"${ridir}/bin/tetris2\"
  ln -sf tetris2 \"${ridir}/bin/tetris\"
  ln -sf tetris2 \"${ridir}/bin/${rname}\"
  install -m 644 tetris.6 \"${ridir}/share/man/man6/tetris.6\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

rname="mksh"
rver="R59"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="http://www.mirbsd.org/MirOS/dist/mir/${rname}/${rfile}"
rsha256="592a28ba67bea8a285f003d7a5d21b65e718546c8fcb375d7d696f3d5dd390ba"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rname}\"
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  mv \"${rname}\" \"${rdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env CC=\"\${CC}\" LDFLAGS='-static' CFLAGS='-Wl,-static' CPPFLAGS= sh Build.sh
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  install -m 0755 \"${rname}\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/ksh\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/ksh88\"
  cwmkdir \"${ridir}/share/man/man1\"
  install -m 0444 lksh.1 mksh.1 \"${ridir}/share/man/man1/\"
  cwmkdir \"${ridir}/share/doc/mksh/examples/\"
  install -m 0444 dot.mkshrc \"${ridir}/share/doc/mksh/examples/\"
  env CC=\"\${CC}\" LDFLAGS='-static' CFLAGS='-Wl,-static' CPPFLAGS='-DMKSH_BINSHPOSIX -DMKSH_BINSHREDUCED' sh Build.sh -L
  install -m 0755 lksh \"${ridir}/bin/lksh\"
  ln -sf \"${rtdir}/current/bin/lksh\" \"${ridir}/bin/sh\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

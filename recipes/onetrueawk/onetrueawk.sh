rname="onetrueawk"
rver="c0f4e97e4561ff42544e92512bbaf3d7d1f6a671"
rdir="${rname#onetrue}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/${rname}/awk/archive/${rfile}"
rsha256=""
rreqs="make byacc"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat makefile > makefile.ORIG
  sed -i 's/-o maketab/-o maketab -static -Wl,-static/g' makefile
  sed -i 's/gcc/\$(CC)/g' makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make YACC=\"${cwsw}/byacc/current/bin/byacc -d -b awkgram\" {HOST,}CC=\"\${CC} -Wl,-static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man1\"
  \$(\${CC} -dumpmachine)-strip --strip-all a.out
  install -m 0755 a.out \"${ridir}/bin/awk\"
  ln -sf \"${rtdir}/current/bin/awk\" \"${ridir}/bin/${rname}\"
  install -m 0644 awk.1 \"${ridir}/share/man/man1/\"
  ln -sf \"${rtdir}/current/share/man/man1/awk.1\" \"${ridir}/share/man/man1/${rname}.1\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

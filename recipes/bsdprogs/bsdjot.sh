rname="bsdjot"
rver="1.27"
rdir="${rname}-${rver}"
rfile="${rdir}.fake"
rurl="http://cvsweb.netbsd.org/bsdweb.cgi/src/usr.bin/jot/"
rsha256="628d638d35dfcf8a6fd1b5e0ede650bb6501e02d40113f6e524f9b61f8b92e29"
rreqs="libbsd pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/jot/jot.c?rev=${rver}\" \"${cwdl}/${rname}/jot.c\" \"${rsha256}\"
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/jot/jot.1?rev=1.16\" \"${cwdl}/${rname}/jot.1\" \"39711d1da08196d3f8670949343c177fa0a7d71b5cdb60dcfea917826be8df1b\"
}
"

eval "
function cwextract_${rname}() {
  cwmkdir \"${rbdir}\"
  cat \"${cwdl}/${rname}/jot.c\" > \"${rbdir}/jot.c\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG s/__dead//g jot.c
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \${CC} jot.c -o jot \$(pkg-config --cflags --libs libbsd-overlay) -static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man1\"
  install -s -m 0755 jot \"${ridir}/bin/\"
  install -m 0644 \"${cwdl}/${rname}/jot.1\" \"${ridir}/share/man/man1/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

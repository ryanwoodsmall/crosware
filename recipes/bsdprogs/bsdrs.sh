rname="bsdrs"
rver="1.16"
rdir="${rname}-${rver}"
rfile="${rdir}.fake"
rurl="http://cvsweb.netbsd.org/bsdweb.cgi/src/usr.bin/rs/"
rsha256="4ccbd6128302b2eaac39aaf63fb6d292888b4de218d0224074ec4e3cfefad2f8"
rreqs="libbsd pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/rs/rs.c?rev=${rver}\" \"${cwdl}/${rname}/rs.c\" \"${rsha256}\"
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/rs/rs.1?rev=1.11\" \"${cwdl}/${rname}/rs.1\" \"1a5753034daf0bdce754342c34615111a7ba1e1deaf2b6c100dd7c7842725916\"
}
"

eval "
function cwextract_${rname}() {
  cwmkdir \"${rbdir}\"
  cat \"${cwdl}/${rname}/rs.c\" > \"${rbdir}/rs.c\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG s/__dead//g rs.c
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \${CC} rs.c -o rs \$(pkg-config --cflags --libs libbsd-overlay) -static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man1\"
  install -s -m 0755 rs \"${ridir}/bin/\"
  install -m 0644 \"${cwdl}/${rname}/rs.1\" \"${ridir}/share/man/man1/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

rname="sc"
rver="7.16"
rdir="${rname}-${rver}"
rfile="${rname}_${rver}.orig.tar.gz"
rurl="http://deb.debian.org/debian/pool/main/s/${rname}/${rfile}"
rsha256="e541f98bcf78ded2de2ce336abda9705a24b6ce67fc82806107880bf6504642a"
rreqs="make ncurses byacc"

. "${cwrecipe}/common.sh"

local df="${rname}_${rver}-4.debian.tar.xz"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \"${rurl//${rfile}/${df}}\" \"${rdlfile//${rfile}/${df}}\" \"8bc1ad000417a9d7c22aa68b75da4d30bd662be04cec91f0c7c381fd06bb07e4\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  cwextract \"${rdlfile//${rfile}/${df}}\" \"${rbdir}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's#^prefix=.*#prefix=${ridir}#g' Makefile
  local p
  for p in \$(cat debian/patches/series) ; do
    patch -p1 < debian/patches/\${p}
  done
  unset p
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make CC=\"\${CC} \${CPPFLAGS}\" YACC=byacc
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/man/man1\"
  cwmkdir \"${ridir}/share/doc\"
  make install
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

unset df

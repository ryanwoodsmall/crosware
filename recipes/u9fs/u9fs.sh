rname="u9fs"
rver="fcec3e1e2e8e8c28b89270e6c44554c4ca9e50a9"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/Plan9-Archive/${rname}/archive/${rfile}"
rsha256="27aca340e7841caf8a982fc0ca0ae993a87c7aafd48ca211ffe9d1450ac54652"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/authrhosts/d' makefile u9fs.c
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make CC=\"\${CC}\" LD=\"\${CC}\" LDFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \$(\${CC} -dumpmachine)-strip --strip-all ${rname}
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man1\"
  install -m 0755 ${rname} \"${ridir}/bin/${rname}\"
  install -m 0644 ${rname}.man \"${ridir}/share/man/man1/${rname}.1\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

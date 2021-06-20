rname="9pro"
rver="d1a7ba61b9c5cf0a7f8246a52653b5980c20ac34"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="0a1e7aa97a2f6e95f423efb86a4e7ffbc31841f90286afaa6937b3b96945254d"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env CC=\"\${CC}\" CFLAGS='-static -Wl,-static' ./build.sh
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  \$(\${CC} -dumpmachine)-strip --strip-all 9pex 9gc
  install -m 0755 9pex \"${ridir}/bin/\"
  install -m 0755 9gc \"${ridir}/bin/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

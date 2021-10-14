rname="entr"
rver="5.0"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/eradman/${rname}/archive/refs/tags/${rfile}"
rsha256="2a87bb7d9e5e89b6f614495937b557dbb8144ea53d0c1fa1812388982cd41ebb"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -Wl,-s -static\" PREFIX=\"${ridir}\" ./configure
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -Wl,-s -static\" PREFIX=\"${ridir}\" make
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -Wl,-s -static\" PREFIX=\"${ridir}\" make install
  popd >/dev/null 2>&1
}
"


eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

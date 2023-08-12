rname="entr"
rver="5.4"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/eradman/${rname}/archive/refs/tags/${rfile}"
rsha256="491dded2cc3f1dcd8d26f496a4c7b3a996b91c7ab20883ca375037a398221f9e"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -Wl,-s -static\" PREFIX=\"\$(cwidir_${rname})\" ./configure
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -Wl,-s -static\" PREFIX=\"\$(cwidir_${rname})\" make
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -Wl,-s -static\" PREFIX=\"\$(cwidir_${rname})\" make install
  popd >/dev/null 2>&1
}
"


eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

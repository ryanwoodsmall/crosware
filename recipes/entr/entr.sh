rname="entr"
rver="5.2"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/eradman/${rname}/archive/refs/tags/${rfile}"
rsha256="237e309d46b075210c0e4cb789bfd0c9c777eddf6cb30341c3fe3dbcc658c380"
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

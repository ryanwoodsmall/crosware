rname="entr"
rver="5.8"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/eradman/entr/archive/refs/tags/${rfile}"
rsha256="dc9a2bdc556b2be900c1d8cdf432de26492de5af3ffade000d4bfd97f3122bfb"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -Wl,-s -static\" PREFIX=\"\$(cwidir_${rname})\" ./configure
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -Wl,-s -static\" PREFIX=\"\$(cwidir_${rname})\" make
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -Wl,-s -static\" PREFIX=\"\$(cwidir_${rname})\" make install
  popd &>/dev/null
}
"


eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

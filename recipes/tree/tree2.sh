rname="tree2"
rver="2.1.3"
rdir="${rname%2}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/Old-Man-Programmer/tree/archive/refs/tags/${rfile}"
rsha256="3ffe2c8bb21194b088ad1e723f0cf340dd434453c5ff9af6a38e0d47e0c2723b"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG \"/^PREFIX.*=/s#/usr.*#\$(cwidir_${rname})#g\" Makefile
  sed -i \"s#^CC=gcc#CC=\${CC}#g\" Makefile
  sed -i 's/^#LDFLAGS.*=.*\$/LDFLAGS=-static/g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  ln -sf tree \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf tree.1 \"\$(cwidir_${rname})/man/man1/${rname}.1\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

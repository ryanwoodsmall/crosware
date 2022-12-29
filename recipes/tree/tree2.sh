rname="tree2"
rver="2.1.0"
rdir="${rname%2}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/Old-Man-Programmer/${rname%2}/archive/refs/tags/${rfile}"
rsha256="e9da64f6bbf894840b76d5fb2d37282076febbc96076fc4e833b08fe42190ad2"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG \"/^PREFIX.*=/s#/usr.*#\$(cwidir_${rname})#g\" Makefile
  sed -i \"s#^CC=gcc#CC=\${CC}#g\" Makefile
  sed -i 's/^#LDFLAGS.*=.*\$/LDFLAGS=-static/g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf tree \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf tree.1 \"\$(cwidir_${rname})/man/man1/${rname}.1\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

rname="tree1"
rver="1.8.0"
rdir="${rname%1}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/Old-Man-Programmer/${rname%1}/archive/refs/tags/${rfile}"
rsha256="eae2aaf21a272fa2416d43bccdc9eaee736dc3287bef92b2685f266940031c61"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG \"/^prefix.*=/s#/usr#\$(cwidir_${rname})#g\" Makefile
  sed -i \"s#^CC=gcc#CC=\${CC}#g\" Makefile
  sed -i 's/^#LDFLAGS=\$/LDFLAGS=-static/g' Makefile
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

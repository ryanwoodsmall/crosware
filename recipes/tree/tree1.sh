rname="tree1"
rver="1.8.0"
rdir="${rname%1}-${rver}"
rfile="${rdir}.tgz"
rurl="http://mama.indstate.edu/users/ice/${rname%1}/src/${rfile}"
rsha256="715d5d4b434321ce74706d0dd067505bb60c5ea83b5f0b3655dae40aa6f9b7c2"
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

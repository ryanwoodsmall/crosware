rname="tree2"
rver="2.1.0"
rdir="${rname%2}-${rver}"
rfile="${rdir}.tgz"
rurl="http://mama.indstate.edu/users/ice/${rname%2}/src/${rfile}"
rsha256="0160c535bff2b0dc6a830b9944e981e3427380f63e748da96ced7071faebabf6"
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

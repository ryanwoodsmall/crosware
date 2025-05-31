rname="outils"
rver="0.14"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/leahneukirchen/outils/archive/${rfile}"
rsha256="e4dcbd92b25bbb371216b0fad5aa80cdff19f466f7ec8b5e145111fb348c91eb"
rreqs="bootstrapmake"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG \"/^PREFIX/s#^PREFIX.*#PREFIX = \$(cwidir_${rname})#g\" Makefile
  sed -i '/^LDFLAGS=/s/^LDFLAGS=/LDFLAGS=-static /g' Makefile
  sed -i '/\\/ts\\/ts:/s,$, src/liboutils/reallocarray.o,g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make -j${cwmakejobs} CC=\"\${CC} \${CFLAGS}\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install CC=\"\${CC} \${CFLAGS}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

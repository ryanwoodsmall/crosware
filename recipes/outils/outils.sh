rname="outils"
rver="0.11"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/leahneukirchen/${rname}/archive/${rfile}"
rsha256="ec970fb5620b752b2a7dcecd868c66c8d187baad3c46d3fced1f5ff55def2587"
rreqs="bootstrapmake"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG \"/^PREFIX/s#^PREFIX.*#PREFIX = \$(cwidir_${rname})#g\" Makefile
  sed -i '/^LDFLAGS=/s/^LDFLAGS=/LDFLAGS=-static /g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} CC=\"\${CC} \${CFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install CC=\"\${CC} \${CFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

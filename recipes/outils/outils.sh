rname="outils"
rver="0.10"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/leahneukirchen/${rname}/archive/${rfile}"
rsha256="6b5101e805c1baa8ca7111b4df8260bfa1b2b7b8670ed341af7233a9971706d4"
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

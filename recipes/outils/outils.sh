rname="outils"
rver="0.12"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/leahneukirchen/${rname}/archive/${rfile}"
rsha256="63b6ebddfb2e6213be1d5b20475321ba6f3221d6f86abe1dc615329c955c24db"
rreqs="bootstrapmake"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG \"/^PREFIX/s#^PREFIX.*#PREFIX = \$(cwidir_${rname})#g\" Makefile
  sed -i '/^LDFLAGS=/s/^LDFLAGS=/LDFLAGS=-static /g' Makefile
  sed -i '/\\/ts\\/ts:/s,$, src/liboutils/reallocarray.o,g' Makefile
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

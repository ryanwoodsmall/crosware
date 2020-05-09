rname="outils"
rver="0.9"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/leahneukirchen/${rname}/archive/${rfile}"
rsha256="b7afdf1a0d11b9d5a0e1ea165ad2841e32b21245ec573170cb6498a13bf43b73"
rreqs="make"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/^PREFIX/s#^PREFIX.*#PREFIX = ${ridir}#g' Makefile
  sed -i '/^LDFLAGS=/s/^LDFLAGS=/LDFLAGS=-static /g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} CC=\"\${CC} \${CFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install CC=\"\${CC} \${CFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

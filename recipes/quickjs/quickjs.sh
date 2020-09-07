#
# XXX - ldflags/cppflags disabled for now
# XXX - official mirror?
# XXX - gitlab mirror? https://gitlab.com/felix.s-git-mirrors/quickjs
# XXX - official github mirror, no tags? https://github.com/bellard/quickjs
#

rname="quickjs"
rver="2020-09-06"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://bellard.org/${rname}/${rfile}"
rsha256="0021a3e8cdc6b61e225411d05e2841d2437e1ccf4b4cabb9a5f7685ebfb57717"
#rfile="${rver}.tar.gz"
#rurl="https://github.com/horhof/${rname}/archive/${rfile}"
#rsha256="99a267894a162fb21cdb95061432910a7c5f0268c7e10b57bebc507586a629a6"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/CONFIG_LTO=y/d' Makefile
  sed -i 's#^prefix=.*#prefix=${ridir}#g' Makefile
  sed -i 's/-shared/-static/g' Makefile
  sed -i 's/-rdynamic/-static/g' Makefile
  sed -i '/^PROGS.*so$/s/PROGS/DISABLED_/g' Makefile
  sed -i '/^PROGS.*test_fib/s/PROGS/DISABLED_/g' Makefile
  sed -i '/^PROGS=/s/run-test262//g' Makefile
  sed -i \"/^CFLAGS_OPT=/s/-O2/-O2 \${CFLAGS}/g\" Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} CC=\"\${CC}\" CXX=\"\${CXX}\" LDFLAGS=-static CONFIG_CC=\${CC}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf qjs \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

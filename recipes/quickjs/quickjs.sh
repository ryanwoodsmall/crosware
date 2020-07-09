#
# XXX - ldflags/cppflags disabled for now
# XXX - official mirror?
# XXX - gitlab mirror? https://gitlab.com/felix.s-git-mirrors/quickjs
#

rname="quickjs"
rver="2020-07-05"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://bellard.org/${rname}/${rfile}"
rsha256="63e9f77a4283cede6b37b75dbbe85cb57edc7dd646367650ac2901d9ef268a99"
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

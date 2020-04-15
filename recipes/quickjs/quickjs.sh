#
# XXX - ldflags/cppflags disabled for now
#

rname="quickjs"
rver="20200119"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/horhof/${rname}/archive/${rfile}"
rsha256="f55481eefa26d7d01346791237b44d0233934872bcd3ee8d4d61744d00a762ef"
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

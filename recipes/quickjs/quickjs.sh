#
# XXX - ldflags/cppflags disabled for now
# XXX - official mirror?
# XXX - gitlab mirror? https://gitlab.com/felix.s-git-mirrors/quickjs
# XXX - official github mirror, no tags? https://github.com/bellard/quickjs
# XXX - undefined atomic_... errors on riscv64: https://github.com/riscv/riscv-gnu-toolchain/issues/183
#

rname="quickjs"
rver="2024-01-13"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://bellard.org/${rname}/${rfile}"
rsha256="3c4bf8f895bfa54beb486c8d1218112771ecfc5ac3be1036851ef41568212e03"
#rfile="${rver}.tar.gz"
#rurl="https://github.com/horhof/${rname}/archive/${rfile}"
#rsha256="99a267894a162fb21cdb95061432910a7c5f0268c7e10b57bebc507586a629a6"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cat Makefile > Makefile.ORIG
  sed -i \"/^PREFIX/s#=.*#=\$(cwidir_${rname})#g\" Makefile
  sed -i \"/^CFLAGS_OPT=/s/-O2/-O2 \${CFLAGS}/g\" Makefile
  sed -i '/CONFIG_LTO=y/d' Makefile
  sed -i 's/-shared/-static/g' Makefile
  sed -i 's/-rdynamic/-static/g' Makefile
  sed -i '/^PROGS.*so$/s/PROGS/DISABLED_/g' Makefile
  sed -i '/^PROGS.*test_fib/s/PROGS/DISABLED_/g' Makefile
  sed -i '/^PROGS=/s/run-test262//g' Makefile
  sed -i 's/-lpthread/-lpthread -latomic/g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} CC=\"\${CC}\" CXX=\"\${CXX}\" LDFLAGS=-static CONFIG_CC=\"\${CC}\" PREFIX=\"\$(cwidir_${rname})\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool} PREFIX=\"\$(cwidir_${rname})\"
  ln -sf qjs \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

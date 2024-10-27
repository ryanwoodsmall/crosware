#
# XXX - ldflags/cppflags disabled for now
# XXX - official mirror?
# XXX - gitlab mirror? https://gitlab.com/felix.s-git-mirrors/quickjs
# XXX - official github mirror, no tags? https://github.com/bellard/quickjs
# XXX - undefined atomic_... errors on riscv64: https://github.com/riscv/riscv-gnu-toolchain/issues/183
#

rname="quickjs"
rver="6e2e68fd0896957f92eb6c242a2e048c1ef3cae0"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
#rfile="${rdir}.tar.xz"
#rurl="https://bellard.org/${rname}/${rfile}"
#rfile="${rver}.tar.gz"
#rurl="https://github.com/horhof/${rname}/archive/${rfile}"
rurl="https://github.com/bellard/quickjs/archive/${rfile}"
rsha256="d4542882686eefa8c0c80493dfb30d858588c0553ffe17a058189132607ff24e"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make -j${cwmakejobs} CC=\"\${CC}\" CXX=\"\${CXX}\" LDFLAGS=-static CONFIG_CC=\"\${CC}\" PREFIX=\"\$(cwidir_${rname})\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool} PREFIX=\"\$(cwidir_${rname})\"
  ln -sf qjs \"\$(cwidir_${rname})/bin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

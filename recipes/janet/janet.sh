#
# XXX - maybe install shared lib .so(s) in ${ridir}/dl? need something similar for lua?
#

rname="janet"
rver="1.16.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/janet-lang/${rname}/archive/refs/tags/${rfile}"
rsha256="84f83b356055557d668dd328a4242bbc652d3cb39e8431666ce391248f4c20e4"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat Makefile > Makefile.ORIG
  sed -i 's,^PREFIX.*,PREFIX=${ridir},g' Makefile
  sed -i '/\\(cp\\|ln\\).*\\.so/s,\\(cp\\|ln\\),echo \\1,g' Makefile
  if [[ ${karch} =~ ^riscv64 ]] ; then
    sed -i.ORIG 's/defined(__aarch64__).*/__riscv_xlen == 64/g' src/include/janet.h
    echo '#undef JANET_ARCH_NAME' >> src/conf/janetconf.h
    echo '#define JANET_ARCH_NAME riscv64' >> src/conf/janetconf.h
  fi
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} CPPFLAGS= LDFLAGS=-static PKG_CONFIG_LDFLAGS= PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool} CPPFLAGS= LDFLAGS=-static PKG_CONFIG_LDFLAGS= PKG_CONFIG_PATH=
  \$(\${CC} -dumpmachine)-strip \"${ridir}/bin/${rname}\"
  sed -i \"s,${ridir},${rtdir}/current,g\" \"${ridir}/bin/jpm\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"

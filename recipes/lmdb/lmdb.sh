rname="lmdb"
rver="0.9.29"
rdir="${rname}-LMDB_${rver}"
rfile="LMDB_${rver}.tar.gz"
rurl="https://github.com/LMDB/${rname}/archive/refs/tags/${rfile}"
rsha256="22054926b426c66d8f2bc22071365df6e35f3aacf19ad943bc6167d4cae3bebb"
rreqs="bootstrapmake"
rbdir="${cwbuild}/${rdir}/libraries/lib${rname}"

. "${cwrecipe}/common.sh"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat Makefile > Makefile.ORIG
  sed -i 's,^prefix.*,prefix = ${ridir},g' Makefile
  sed -i 's,^ILIBS.*,ILIBS = lib${rname}.a,g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} CC=\"\${CC}\" CPPFLAGS= LDFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  \$(\${CC} -dumpmachine)-strip --strip-all ${ridir}/bin/*
  popd >/dev/null 2>&1
}
"

#eval "
#function cwgenprofd_${rname}() {
#  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
#  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
#  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
#}
#"

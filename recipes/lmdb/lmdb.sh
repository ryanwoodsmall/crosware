rname="lmdb"
rver="1.0.0"
rdir="${rname}-LMDB_${rver}"
rfile="LMDB_${rver}.tar.gz"
rurl="https://github.com/LMDB/${rname}/archive/refs/tags/${rfile}"
rsha256="44a5ec3a8d71b4287244c538ee80a95e2af40b1a4ee04553359f044c7939734a"
rreqs="bootstrapmake"
rbdir="${cwbuild}/${rdir}/libraries/lib${rname}"

. "${cwrecipe}/common.sh"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  rm -rf \"${rdir}\"
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  cat Makefile > Makefile.ORIG
  sed -i 's,^prefix.*,prefix = ${ridir},g' Makefile
  sed -i 's,^ILIBS.*,ILIBS = lib${rname}.a,g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make -j${cwmakejobs} CC=\"\${CC}\" CPPFLAGS= LDFLAGS=-static
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make install ${rlibtool}
  \$(\${CC} -dumpmachine)-strip --strip-all ${ridir}/bin/*
  popd &>/dev/null
}
"

#eval "
#function cwgenprofd_${rname}() {
#  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
#  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
#  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
#}
#"

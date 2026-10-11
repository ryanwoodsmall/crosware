rsname="lmdb"
rname="${rsname}0"
rver="0.9.36"
rdir="${rsname}-LMDB_${rver}"
rfile="LMDB_${rver}.tar.gz"
rurl="https://github.com/LMDB/lmdb/archive/refs/tags/${rfile}"
rsha256="7d55c3cbc1ef55f9b0076d3ddb16d0d9996d05b9caa7ca889ce10430ac677b90"
rreqs="bootstrapmake"
rbdir="${cwbuild}/${rdir}/libraries/lib${rsname}"

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
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat Makefile > Makefile.ORIG
  sed -i \"s,^prefix.*,prefix = \$(cwidir_${rname}),g\" Makefile
  sed -i \"s,^ILIBS.*,ILIBS = lib${rsname}.a,g\" Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make -j${cwmakejobs} CC=\"\${CC}\" CPPFLAGS= LDFLAGS=-static
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  \$(\${CC} -dumpmachine)-strip --strip-all \$(cwidir_${rname})/bin/*
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

unset rsname

# vim: set ft=bash:

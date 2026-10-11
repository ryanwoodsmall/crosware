#
# XXX - 0.96.x and 1.x db formats are incompatible
# XXX - added lmdb0, move this to lmdb1?
# XXX - add a virtual lmdb recipe?
# XXX - am i actually using this?
#
rname="lmdb"
rver="1.0.2"
rdir="${rname}-LMDB_${rver}"
rfile="LMDB_${rver}.tar.gz"
rurl="https://github.com/lmdb/lmdb/archive/refs/tags/${rfile}"
rsha256="17e4cb8e80874fccc1ff6f7d5fdb62f029624967d001ff40c47c0fb7a5b42d7d"
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
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat Makefile > Makefile.ORIG
  sed -i \"s,^prefix.*,prefix = \$(cwidir_${rname}),g\" Makefile
  sed -i \"s,^ILIBS.*,ILIBS = lib${rname}.a,g\" Makefile
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

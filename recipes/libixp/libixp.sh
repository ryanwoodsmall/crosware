#
# XXX - ixpc segfaults on a ryzen9 3900x randomly, in debian and under docker?
# XXX - SIGSEGV in asctime_r/strlen/strdup in a container - crosware, alpine, centos:7
#
rname="libixp"
rver="39bc91ae4daa39cdf0ff0bb18f8429cdacaf8a79"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/0intro/${rname}/archive/${rfile}"
rsha256="d7f5766d12341d1d1c00d41806362be61142ebb7264a61b9c26f97e8dec4e745"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

# XXX - man pages require txt2tags, python - just disable and run install twice
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat config.mk > config.mk.ORIG
  sed -i \"/^CC/s,^.*,CC=\${CC} -c,g\" config.mk
  sed -i '/^LIBS/s,^.*,LIBS=-static,g' config.mk
  sed -i 's,-I/usr/include,,g' config.mk
  sed -i \"/^PREFIX/s,^.*,PREFIX=\$(cwidir_${rname}),g\" config.mk
  cat Makefile > Makefile.ORIG
  sed -i 's,man,include,g' Makefile
  : sed -i '/PHONY:/s,doc,,g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/ixpc\"
  rm -f  \"\$(cwidir_${rname})/bin/9p\" || true
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man3\"
  install -m 0644 man/*.1 \"\$(cwidir_${rname})/share/man/man1/\"
  install -m 0644 man/*.3 \"\$(cwidir_${rname})/share/man/man3/\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

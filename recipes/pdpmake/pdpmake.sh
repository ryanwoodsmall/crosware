#
# XXX - check macros: ENABLE_FEATURE_CLEAN_UP
#
rname="pdpmake"
rver="2.0.3"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/rmyorston/${rname}/archive/refs/tags/${rfile}"
rsha256="92fe09b614ebe94de25154b383cc136b07f75e26d5e2febf27a343c4b8fa18ad"
rreqs="bootstrapmake txt2man"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/(CC)/s/(OBJS)/(OBJS) -static/g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  rm -f ${rname} posixmake make
  make CC=\"\${CC} \${CFLAGS} -Os -g0 -Wl,-s -DENABLE_FEATURE_MAKE_EXTENSIONS=0 -DENABLE_FEATURE_MAKE_POSIX_2024=0\" CPPFLAGS= LDFLAGS='-static -s'
  mv make posixmake
  make clean
  make CC=\"\${CC} \${CFLAGS} -Os -g0 -Wl,-s -DENABLE_FEATURE_MAKE_EXTENSIONS=1 -DENABLE_FEATURE_MAKE_POSIX_2024=1\" CPPFLAGS= LDFLAGS='-static -s'
  mv make ${rname}
  make ${rname}.1
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  install -m 644 ${rname}.1 \"\$(cwidir_${rname})/share/man/man1/${rname}.1\"
  install -m 755 ${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 755 posixmake \"\$(cwidir_${rname})/bin/posixmake\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/${rname}\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/posixmake\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

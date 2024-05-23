#
# XXX - check macros: ENABLE_FEATURE_CLEAN_UP
#
rname="pdpmake"
rver="1.4.2"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/rmyorston/${rname}/archive/refs/tags/${rfile}"
rsha256="e34aa44a9319315a16d59fd0a9b514cfd1131466774541d5a4dcdfc2ac8bbb26"
rreqs="bootstrapmake"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG '/(CC)/s/(OBJS)/(OBJS) -static/g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  rm -f ${rname} posixmake make
  make CC=\"\${CC} \${CFLAGS} -Os -g0 -Wl,-s\" CPPFLAGS= LDFLAGS='-static -s'
  mv make posixmake
  make clean
  make CC=\"\${CC} \${CFLAGS} -Os -g0 -Wl,-s -DENABLE_FEATURE_MAKE_EXTENSIONS=1 -DENABLE_FEATURE_MAKE_POSIX_202X=1\" CPPFLAGS= LDFLAGS='-static -s'
  mv make ${rname}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 ${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 755 posixmake \"\$(cwidir_${rname})/bin/posixmake\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/${rname}\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/posixmake\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

#
# XXX - check macros: ENABLE_FEATURE_MAKE_POSIX_202X ENABLE_FEATURE_CLEAN_UP
#

rname="pdpmake"
rver="1.3.0"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/rmyorston/${rname}/archive/refs/tags/${rfile}"
rsha256="1242d2171398a03a82a4b57c9b710de74e4efff41e8f5b1e4f60f2dd7c6451c1"
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
  make CC=\"\${CC} \${CFLAGS}\" CPPFLAGS= LDFLAGS=-static
  mv make posixmake
  make clean
  make CC=\"\${CC} \${CFLAGS} -DENABLE_FEATURE_MAKE_EXTENSIONS=1\" CPPFLAGS= LDFLAGS=-static
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
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

#
# XXX - check macros: ENABLE_FEATURE_CLEAN_UP
# XXX - can use txt2man to generate manpages: https://github.com/mvertes/txt2man
#
rname="pdpmake"
rver="1.4.3"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/rmyorston/${rname}/archive/refs/tags/${rfile}"
rsha256="e078ab376683de2a3044826c301f0cdef1147065f5244b52af33727797489819"
rreqs="bootstrapmake"
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
  make CC=\"\${CC} \${CFLAGS} -Os -g0 -Wl,-s\" CPPFLAGS= LDFLAGS='-static -s'
  mv make posixmake
  make clean
  make CC=\"\${CC} \${CFLAGS} -Os -g0 -Wl,-s -DENABLE_FEATURE_MAKE_EXTENSIONS=1 -DENABLE_FEATURE_MAKE_POSIX_202X=1\" CPPFLAGS= LDFLAGS='-static -s'
  mv make ${rname}
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
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

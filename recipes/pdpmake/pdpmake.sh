rname="pdpmake"
rver="1.2.0"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/rmyorston/${rname}/archive/refs/tags/${rfile}"
rsha256="c545301f4031eb2705196e789e19cd83fe954f62f6ebb9e7e8cf3191884ada17"
rreqs="bootstrapmake"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/(CC)/s/(OBJS)/(OBJS) -static/g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
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
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  install -m 755 ${rname} \"${ridir}/bin/${rname}\"
  install -m 755 posixmake \"${ridir}/bin/posixmake\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

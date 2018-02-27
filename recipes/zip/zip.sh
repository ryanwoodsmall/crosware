rname="zip"
rver="2.32"
rdir="${rname}-${rver}"
rfile="${rname}${rver//./}.tgz"
rurl="ftp://ftp.info-zip.org/pub/infozip/src/${rfile}"
rsha256="d0d3743f732a9baa162f80d0c4567b9c545b41a3385825042113810f2a56eb2f"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cp unix/Makefile{,.ORIG}
  sed -i \"s|^prefix =.*|prefix = ${ridir}|g\" unix/Makefile
  sed -i \"s|^CC =.*|CC = \${CC} \${CFLAGS} -static|g\" unix/Makefile
  sed -i \"s|^CPP =.*|CPP = \${CPP}|g\" unix/Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make -f unix/Makefile generic
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make -f unix/Makefile install
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

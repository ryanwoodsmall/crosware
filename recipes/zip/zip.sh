rname="zip"
rver="30"
rdir="${rname}${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/infozip/files/Zip%203.x%20%28latest%29/3.0/${rfile}/download"
rsha256="f0e8bb1f9b7eb0b01285495a2699df3a4b766784c1765a8f1aeedf63c0806369"
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

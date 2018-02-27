rname="unzip"
rver="60"
rdir="${rname}${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/infozip/files/UnZip%206.x%20%28latest%29/UnZip%206.0/${rfile}/download"
rsha256="036d96991646d0449ed0aa952e4fbe21b476ce994abc276e49d30e686708bd37"
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

# prepend here to override busybox unzip
eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

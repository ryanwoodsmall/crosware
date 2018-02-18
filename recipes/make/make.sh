rname="make"
rver="4.2.1"
rurl="https://ftp.gnu.org/gnu/${rname}/${rname}-${rver}.tar.bz2"
rfile="$(basename ${rurl})"
rdir="${rfile//.tar.bz2/}"
rsha256="d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd ${cwbuild}/${rdir} >/dev/null 2>&1
  ./configure --prefix="${cwsw}/${rname}/${rdir}" --disable-load
  popd >/dev/null 2>&1
}
"

eval "
function cwbuild_${rname}() {
  pushd ${cwbuild}/${rdir} >/dev/null 2>&1
  ./build.sh
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd ${cwbuild}/${rdir} >/dev/null 2>&1
  ./make install-binPROGRAMS
  popd >/dev/null 2>&1
}
"

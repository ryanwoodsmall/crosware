#
# XXX - need to fixup .pc with -L${cwsw}/libmd/current/lib as well?
#

rname="libbsd"
rver="0.11.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://libbsd.freedesktop.org/releases/${rfile}"
rsha256="1a9c952525635c1bb6770cb22e969b938d8e6a9d7912362b98ee8370599b0efd"
rreqs="make libmd"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} LDFLAGS='-L${cwsw}/libmd/current/lib -static' CPPFLAGS='-I${cwsw}/libmd/current/include'
  echo '#include <fcntl.h>' >> config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"

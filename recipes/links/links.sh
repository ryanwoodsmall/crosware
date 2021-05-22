#
# XXX - libressl variant
#

rname="links"
rver="2.22"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="http://links.twibright.com/download/${rfile}"
rsha256="0364986b3a7f1e8e3171bea362b53f71e1dd3360a8842d66fdc65580ebc2084d"
rreqs="make libevent zlib openssl xz bzip2 lzlib cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --with-ssl --disable-graphics --without-x
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'alias links=\"links -ssl.certificates 0\"' >> "${rprof}"
}
"

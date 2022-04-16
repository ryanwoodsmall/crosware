rname="links"
rver="2.26"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="http://links.twibright.com/download/${rfile}"
rsha256="f05b3577f25dbe63e491c424f0ecb31f7bfadce9b2bc2f111dfed049c004c9cb"
rreqs="make libevent zlib openssl xz bzip2 lzlib cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --with-ssl --with-ipv6 --disable-graphics --without-x
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

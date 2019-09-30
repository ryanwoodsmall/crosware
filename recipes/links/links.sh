rname="links"
rver="2.20.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="http://links.twibright.com/download/${rfile}"
rsha256="4b4f07d0e6261118d1365a5a5bfa31e1eafdbd280cfae6f0e9eedfea51a2f424"
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

rname="links"
rver="2.15"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="http://links.twibright.com/download/${rfile}"
rsha256="1e2a1c4b439c14fbedd78fd98f443af2ab0c1566bebc491642411d74b7efe3ca"
rreqs="make libevent zlib openssl"

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

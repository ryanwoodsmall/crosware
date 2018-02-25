rname="links"
rver="2.14"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://links.twibright.com/download/${rfile}"
rsha256="22fa8dcb5a60b8ffd611de31ebd4c79edce472637a3554bab401795da91d4387"
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
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

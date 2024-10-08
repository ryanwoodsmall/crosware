rname="links"
rver="2.30"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="http://links.twibright.com/download/${rfile}"
rsha256="c4631c6b5a11527cdc3cb7872fc23b7f2b25c2b021d596be410dadb40315f166"
rreqs="make libevent zlib openssl xz bzip2 lzlib cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} --with-ssl --with-ipv6 --disable-graphics --without-x
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

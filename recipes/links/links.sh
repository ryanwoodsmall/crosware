rname="links"
rver="2.29"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="http://links.twibright.com/download/${rfile}"
rsha256="22aa96c0b38e1a6f8f7ed9d7a4167a47fc37246097759ef6059ecf8f9ead7998"
rreqs="make libevent zlib openssl xz bzip2 lzlib cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --with-ssl --with-ipv6 --disable-graphics --without-x
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

rname="openvpn"
rver="2.5.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://swupdate.openvpn.org/community/releases/${rfile}"
rsha256="56c0dcd27ab938c4ad07469c86eb8b7408ef64c3e68f98497db8c03f11792436"
rreqs="make openssl zlib lzo lz4 pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-{plugins,shared} \
    --enable-{lz4,lzo,static} \
    --with-crypto-library=openssl \
      CPPFLAGS=\"\$(echo -I${cwsw}/{openssl,zlib,lzo,lz4}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{openssl,zlib,lzo,lz4}/current/lib) -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"

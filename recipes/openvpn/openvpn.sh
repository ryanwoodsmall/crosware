rname="openvpn"
rver="2.6.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://swupdate.openvpn.org/community/releases/${rfile}"
rsha256="ebec933263c9850ef6f7ce125e2f22214be60b1cbb8ccff18892643fe083ae8f"
rreqs="make openssl zlib lzo lz4 pkgconfig libcapng"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-{plugins,shared} \
    --enable-{lz4,lzo,static} \
    --with-crypto-library=openssl \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"

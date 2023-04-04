rname="openvpn"
rver="2.6.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://swupdate.openvpn.org/community/releases/${rfile}"
rsha256="42d561a9af150b21bc914e3b7aa09f88013d2ffa6d5ce75a025a3b34caa948d4"
rreqs="make openssl zlib lzo lz4 pkgconfig libcapng"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-{dco,plugins,shared} \
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

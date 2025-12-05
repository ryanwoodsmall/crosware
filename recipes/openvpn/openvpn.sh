rname="openvpn"
rver="2.6.17"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://swupdate.openvpn.org/community/releases/${rfile}"
rsha256="4cc8e63f710d3001493b13d8a32cf22a214d5e4f71dd37d93831e2fd3208b370"
rreqs="make openssl zlib lzo lz4 pkgconfig libcapng"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    --disable-{dco,plugins,shared} \
    --enable-{lz4,lzo,static} \
    --with-crypto-library=openssl \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"

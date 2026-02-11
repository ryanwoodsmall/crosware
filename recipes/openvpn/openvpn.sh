#
# XXX - openvpn 2.7.x needs mbedtls 3.2 or newer:
#   checking mbedtls version... configure: error: mbed TLS version >= 3.2.1 required
#
# XXX - wolfssl breaks on 2.7.x as well:
#   ssl_verify_openssl.c: In function 'backend_x509_get_username':
#   ssl_verify_openssl.c:260:21: error: 'LN_serialNumber' undeclared (first use in this function); did you mean 'NID_serialNumber'?
#     260 |     else if (strcmp(LN_serialNumber, x509_username_field) == 0)
#         |                     ^~~~~~~~~~~~~~~
#         |                     NID_serialNumber
#   ssl_verify_openssl.c:260:21: note: each undeclared identifier is reported only once for each function it appears in
#   make[3]: *** [Makefile:814: ssl_verify_openssl.o] Error 1
#
rname="openvpn"
rver="2.6.19"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://swupdate.openvpn.org/community/releases/${rfile}"
rsha256="13702526f687c18b2540c1a3f2e189187baaa65211edcf7ff6772fa69f0536cf"
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

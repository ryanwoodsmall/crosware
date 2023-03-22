rprovider="mbedtls"
rname="uacme${rprovider}"
rreqs="make curl${rprovider} ${rprovider} nghttp2 zlib libssh2mbedtls pkgconfig"
. "${cwrecipe}/${rname%${rprovider}}/${rname%${rprovider}}tlsprovider.sh.common"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/curl${rprovider}/current/devbin:\${PATH}\" \
    ./configure \
      ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --disable-docs \
      --with-libcurl=\"${cwsw}/curl${rprovider}/current\" \
      --with-${rprovider}=\"${cwsw}/${rprovider}/current\" \
      --without-openssl \
      --without-gnutls \
        CC=\"\${CC} -g0 -Os -Wl,-s\" \
        CXX=\"\${CXX} -g0 -Os -Wl,-s\" \
        CFLAGS=\"\${CFLAGS} -g0 -Os -Wl,-s\" \
        CXXFLAGS=\"\${CXXFLAGS} -g0 -Os -Wl,-s\" \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        LIBS='-lcurl -latomic -lssh2 -lnghttp2 -lz -lmbedx509 -lmbedtls -lmbedcrypto -static' \
        PKG_CONFIG=\"${cwsw}/pkgconfig/current/bin/pkg-config\"
  popd >/dev/null 2>&1
}
"

unset rprovider

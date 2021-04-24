rprovider="mbedtls"
rname="uacme${rprovider}"
rreqs="make curl${rprovider} ${rprovider} nghttp2 zlib libssh2libgcrypt libgcrypt libgpgerror pkgconfig"
. "${cwrecipe}/${rname%${rprovider}}/${rname%${rprovider}}tlsprovider.sh.common"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/curl${rprovider}/current/devbin:\${PATH}\" \
    ./configure \
      ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --disable-docs \
      --with-libcurl=\"${cwsw}/curl${rprovider}/current\" \
      --with-${rprovider}=\"${cwsw}/${rprovider}/current\" \
      --without-openssl \
      --without-gnutls \
        CPPFLAGS=\"\$(echo -I${cwsw}/{curl${rprovider},zlib,nghttp2,libssh2libgcrypt,libgcrypt,libgpgerror,${rprovider}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{curl${rprovider},zlib,nghttp2,libssh2libgcrypt,libgcrypt,libgpgerror,${rprovider}}/current/lib) -static\" \
        LIBS='-lcurl -lssh2 -lgcrypt -lgpg-error -lnghttp2 -lz -lmbedx509 -lmbedtls -lmbedcrypto -static' \
        PKG_CONFIG=\"${cwsw}/pkgconfig/current/bin/pkg-config\" \
        PKG_CONFIG_LIBDIR= \
        PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

unset rprovider

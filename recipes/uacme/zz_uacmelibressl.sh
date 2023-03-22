#
# XXX - no ualpn: https://github.com/ndilieto/uacme/commit/32546c7c
#
rprovider="libressl"
rname="uacme${rprovider}"
rreqs="make curl${rprovider} ${rprovider} nghttp2 zlib libssh2libressl pkgconfig"
. "${cwrecipe}/${rname%${rprovider}}/${rname%${rprovider}}tlsprovider.sh.common"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/curl${rprovider}/current/devbin:\${PATH}\" \
    ./configure \
      ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --disable-docs \
      --with-libcurl=\"${cwsw}/curl${rprovider}/current\" \
      --with-openssl=\"${cwsw}/${rprovider}/current\" \
      --without-gnutls \
      --without-mbedtls \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        LIBS='-lcurl -latomic -lssh2 -lnghttp2 -lz -lssl -lcrypto -static' \
        PKG_CONFIG=\"${cwsw}/pkgconfig/current/bin/pkg-config\"
  popd >/dev/null 2>&1
}
"

unset rprovider

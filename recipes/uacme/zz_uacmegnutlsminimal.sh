rprovider="gnutlsminimal"
rname="uacme${rprovider}"
rreqs="make curl${rprovider} ${rprovider} nettleminimal nghttp2 zlib libssh2libgcrypt libgcrypt libgpgerror pkgconfig"
. "${cwrecipe}/${rname%${rprovider}}/${rname%${rprovider}}tlsprovider.sh.common"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/curl${rprovider}/current/devbin:\${PATH}\" \
    ./configure \
      ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --disable-docs \
      --with-libcurl=\"${cwsw}/curl${rprovider}/current\" \
      --with-${rprovider%minimal}=\"${cwsw}/${rprovider}/current\" \
      --without-openssl \
      --without-mbedtls \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        LIBS='-lcurl -latomic -lssh2 -lgcrypt -lgpg-error -lnghttp2 -lz -lgnutls -lhogweed -lnettle -static' \
        PKG_CONFIG=\"${cwsw}/pkgconfig/current/bin/pkg-config\"
  popd >/dev/null 2>&1
}
"

unset rprovider

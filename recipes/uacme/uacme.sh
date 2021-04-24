#
# XXX - mbedtls - default since it's smallest support tls provider
# XXX - supports openssl and gnutls as well - need variants
#

rname="uacme"
rver="1.7"
rdir="${rname}-upstream-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/ndilieto/${rname}/archive/refs/tags/upstream/1.7.tar.gz"
rsha256="32ca99851194cadb16c05f3c5d32892b0b93fc247321de2b560fa0f667e6cf04"
rreqs="make curlmbedtls mbedtls nghttp2 zlib libssh2libgcrypt libgcrypt libgpgerror pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=${cwsw}/curlmbedtls/current/devbin:\${PATH} \
    ./configure \
      ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --disable-docs \
      --with-libcurl=\"${cwsw}/curlmbedtls/current\" \
      --with-mbedtls=\"${cwsw}/mbedtls/current\" \
      --without-openssl \
      --without-gnutls \
        CPPFLAGS=\"\$(echo -I${cwsw}/{curlmbedtls,zlib,nghttp2,libssh2libgcrypt,libgcrypt,libgpgerror,mbedtls}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{curlmbedtls,zlib,nghttp2,libssh2libgcrypt,libgcrypt,libgpgerror,mbedtls}/current/lib) -static\" \
        LIBS='-lcurl -lssh2 -lgcrypt -lgpg-error -lnghttp2 -lz -lmbedx509 -lmbedtls -lmbedcrypto -static' \
        PKG_CONFIG=\"${cwsw}/pkgconfig/current/bin/pkg-config\" \
        PKG_CONFIG_LIBDIR= \
        PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

rname="curllibressl"
rver="$(cwver_curl)"
rdir="$(cwdir_curl)"
rfile="$(cwfile_curl)"
rdlfile="$(cwdlfile_curl)"
rurl="$(cwurl_curl)"
rsha256=""
rreqs="make zlib libressl cacertificates nghttp2 pkgconfig libssh2libressl"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname%libressl}/${rname%libressl}.sh.common"

eval "
function cwmakeinstall_${rname}() {
  cwclean_${rname}
  cwextract_${rname}
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-dependency-tracking \
    --disable-maintainer-mode \
    --enable-headers-api \
    --enable-ipv6 \
    --with-libssh2=\"${cwsw}/libssh2libressl/current\" \
    --with-nghttp2=\"${cwsw}/nghttp2/current\" \
    --with-zlib=\"${cwsw}/zlib/current\" \
    --without-brotli \
    --without-hyper \
    --without-libidn2 \
    --without-libpsl \
    --without-zstd \
    --without-bearssl \
    --without-wolfssh \
    --without-wolfssl \
    --without-gnutls \
    --without-mbedtls \
    --with-openssl=\"${cwsw}/libressl/current\" \
    --with-default-ssl-backend=openssl \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
    --with-ca-path=\"${cwetc}/ssl/certs\" \
      LDFLAGS=\"-L${cwsw}/zlib/current/lib -L${cwsw}/libressl/current/lib -static\" \
      CPPFLAGS=\"-I${cwsw}/zlib/current/include -I${cwsw}/libressl/current/include\" \
      PKG_CONFIG_PATH=\"${cwsw}/nghttp2/current/lib/pkgconfig\" \
      PKG_CONFIG_LIBDIR=\"${cwsw}/nghttp2/current/lib/pkgconfig\" \
      LIBS='-latomic'
  echo '#include <sched.h>' >> lib/curl_config.h
  echo '#include <stdatomic.h>' >> lib/curl_config.h
  make -j${cwmakejobs} ${rlibtool}
  make install ${rlibtool}
  rm -f \"${ridir}/bin/curl-${rname#curl}\" \"${ridir}/bin/${rname%libressl}-libressl-config\"
  mv \"${ridir}/bin/${rname%libressl}\" \"${ridir}/bin/curl-${rname#curl}\"
  mv \"${ridir}/bin/${rname%libressl}-config\" \"${ridir}/bin/curl-${rname#curl}-config\"
  test -e \"${ridir}/bin/${rname}\" || ln -sf \"curl-${rname#curl}\" \"${ridir}/bin/${rname}\"
  cwmkdir \"${ridir}/devbin\"
  ln -sf \"${rtdir}/current/bin/curl-${rname#curl}-config\" \"${ridir}/devbin/curl-config\"
  sed -i 's/ -lcurl / -lcurl -latomic /g' \"\$(cwidir_${rname})/lib/pkgconfig/libcurl.pc\"
  popd >/dev/null 2>&1
}
"

rname="curllibressl"
rver="$(cwver_curl)"
rdir="$(cwdir_curl)"
rfile="$(cwfile_curl)"
rdlfile="$(cwdlfile_curl)"
rurl="$(cwurl_curl)"
rsha256=""
rreqs="make zlib libressl cacertificates nghttp2 pkgconfig libssh2libressl caextract"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname%libressl}/${rname%libressl}.sh.common"

eval "
function cwmakeinstall_${rname}() {
  cwclean_${rname}
  cwextract_${rname}
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  local e='--enable-docs --enable-manual'
  if ! command -v perl &>/dev/null ; then
    cwfuncecho 'no perl; disabling docs/manual'
    e='--disable-docs --disable-manual'
    sed -i '/SUBDIRS.*docs/s,\\(docs\\|cmdline-opts\\),,g' Makefile.in
    sed -i '/SUBDIRS.*docs/s,../docs,,g' src/Makefile.in
    sed -i 's,^SUBDIRS.*,SUBDIRS=libcurl,g' docs/Makefile.in
  fi
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
      \${e} \
      LDFLAGS=\"-L${cwsw}/zlib/current/lib -L${cwsw}/libressl/current/lib -static\" \
      CPPFLAGS=\"-I${cwsw}/zlib/current/include -I${cwsw}/libressl/current/include\" \
      PKG_CONFIG_PATH=\"${cwsw}/nghttp2/current/lib/pkgconfig\" \
      PKG_CONFIG_LIBDIR=\"${cwsw}/nghttp2/current/lib/pkgconfig\" \
      LIBS='-latomic'
  echo '#include <sched.h>' >> lib/curl_config.h
  echo '#include <stdatomic.h>' >> lib/curl_config.h
  make -j${cwmakejobs} ${rlibtool}
  make install ${rlibtool}
  rm -f \"\$(cwidir_${rname})/bin/curl-${rname#curl}\" \"\$(cwidir_${rname})/bin/${rname%libressl}-libressl-config\"
  mv \"\$(cwidir_${rname})/bin/${rname%libressl}\" \"\$(cwidir_${rname})/bin/curl-${rname#curl}\"
  mv \"\$(cwidir_${rname})/bin/${rname%libressl}-config\" \"\$(cwidir_${rname})/bin/curl-${rname#curl}-config\"
  test -e \"\$(cwidir_${rname})/bin/${rname}\" || ln -sf \"curl-${rname#curl}\" \"\$(cwidir_${rname})/bin/${rname}\"
  cwmkdir \"\$(cwidir_${rname})/devbin\"
  ln -sf \"${rtdir}/current/bin/curl-${rname#curl}-config\" \"\$(cwidir_${rname})/devbin/curl-config\"
  sed -i 's/ -lcurl / -lcurl -latomic /g' \"\$(cwidir_${rname})/lib/pkgconfig/libcurl.pc\"
  unset e
  popd &>/dev/null
}
"

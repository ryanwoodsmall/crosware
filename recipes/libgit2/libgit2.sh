#
# XXX - libressl variant
# XXX - mbedtls variant
# XXX - lib64 fix - cmake?
#
rname="libgit2"
rver="1.9.6"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/libgit2/libgit2/archive/refs/tags/${rfile}"
rsha256="a88a42a4ea9bdab7aa8686eead3bf7d9c6dd74529caca16ab22eaa92433d31d9"
rreqs="make zlib pkgconfig openssl libssh2 cmake"
rbdir="${cwbuild}/${rdir}/build"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  cwmkdir \"\$(cwbdir_${rname})\"
  local extra=''
  test -z \"\$(which -a python python2 python3)\" && extra='-DBUILD_TESTS=OFF' || true
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    PATH=\"${cwsw}/cmake/current/bin:${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    CC=\"\${CC} -I${cwsw}/openssl/current/include\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      cmake .. \
        \${extra} \
        -DBUILD_CLAR=OFF \
        -DBUILD_SHARED_LIBS=OFF \
        -DLIBSSH2_INCLUDE_DIR=\"${cwsw}/libssh2/current/include\" \
        -DLIBSSH2_LIBRARY=\"${cwsw}/libssh2/current/lib/libssh2.a\" \
        -DLINK_WITH_STATIC_LIBRARIES=ON \
        -DUSE_SSH=ON \
        -DUSE_HTTPS=ON \
        -DUSE_BUNDLED_ZLIB=OFF \
        -DSHA1_BACKEND=OpenSSL \
        -DUSE_EXT_HTTP_PARSER=OFF \
        -DCMAKE_INSTALL_PREFIX=\"\$(cwidir_${rname})\" \
        -DOPENSSL_INCLUDE_DIR=\"${cwsw}/openssl/current/include\" \
        -DOPENSSL_CRYPTO_LIBRARY=\"${cwsw}/openssl/current/lib/libcrypto.a\" \
        -DOPENSSL_SSL_LIBRARY=\"${cwsw}/openssl/current/lib/libssl.a\" \
        -DZLIB_LIBRARY=\"${cwsw}/zlib/current/lib/libz.a\" \
        -DZLIB_INCLUDE_DIR=\"${cwsw}/zlib/current/include\"
  sed -i.ORIG '/Requires.private/s/\\.private:/:/g' ${rname}.pc
  sed -i '/^Requires/s/\$/ libssh2 libssl libcrypto zlib/g' ${rname}.pc
  unset extra
  popd &>/dev/null
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  rm -rf \"\$(cwdir_${rname})\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

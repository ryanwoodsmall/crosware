#
# XXX - mbedtls variant
#

rname="libgit2"
rver="1.4.2"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/refs/tags/${rfile}"
rsha256="901c2b4492976b86477569502a41c31b274b69adc177149c02099ea88404ef19"
rreqs="make zlib pkgconfig openssl libssh2 cmake"
rbdir="${cwbuild}/${rdir}/build"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  cwmkdir \"${rbdir}\"
  local extra=''
  test -z \"\$(which -a python python2 python3)\" && extra='-DBUILD_TESTS=OFF' || true
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/cmake/current/bin:${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    cmake .. \
      \${extra} \
      -DBUILD_CLAR=OFF \
      -DBUILD_SHARED_LIBS=OFF \
      -DUSE_SSH=ON \
      -DUSE_HTTPS=ON \
      -DUSE_BUNDLED_ZLIB=OFF \
      -DSHA1_BACKEND=OpenSSL \
      -DUSE_EXT_HTTP_PARSER=OFF \
      -DCMAKE_INSTALL_PREFIX=\"${ridir}\" \
      -DZLIB_LIBRARY=\"${cwsw}/zlib/current/lib/libz.a\" \
      -DZLIB_INCLUDE_DIR=\"${cwsw}/zlib/current/include\"
  sed -i.ORIG '/Requires.private/s/\\.private:/:/g' ${rname}.pc
  sed -i '/^Requires/s/\$/ libcrypto libssl libssh2 zlib/g' ${rname}.pc
  unset extra
  popd >/dev/null 2>&1
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"

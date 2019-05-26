rname="libgit2"
rver="0.28.2"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/${rfile}"
rsha256="42b5f1e9b9159d66d86fff0394215c5733b6ef8f9b9d054cdd8c73ad47177fc3"
rreqs="make zlib pkgconfig openssl libssh2 cmake"
rbdir="${cwbuild}/${rdir}/build"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  cwmkdir \"${rbdir}\"
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/cmake/current/bin:${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    cmake .. \
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

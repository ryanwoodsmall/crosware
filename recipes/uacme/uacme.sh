rname="uacme"
rver="1.7"
rdir="${rname}-upstream-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/ndilieto/${rname}/archive/refs/tags/upstream/${rfile}"
rsha256="32ca99851194cadb16c05f3c5d32892b0b93fc247321de2b560fa0f667e6cf04"
rreqs="make curl zlib openssl libssh2 expat libmetalink cacertificates nghttp2 pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/curl/current/bin:\${PATH}\" \
    ./configure \
      ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --disable-docs \
      --with-libcurl=\"${cwsw}/curl/current\" \
      --with-openssl=\"${cwsw}/openssl/current\" \
      --without-gnutls \
      --without-mbedtls \
        LIBS='-lcurl -lssh2 -lnghttp2 -lz -lmetalink -lexpat -lssl -lcrypto -static'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

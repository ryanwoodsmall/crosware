rname="uacme"
rver="1.7.1"
rdir="${rname}-upstream-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/ndilieto/${rname}/archive/refs/tags/upstream/${rfile}"
rsha256="36027a587256cbaa86650cec2a5b3eb000480e1150bd83941565661b392625ac"
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
        LIBS='-lcurl -lssh2 -lnghttp2 -lz -lmetalink -lexpat -lssl -lcrypto -static' \
        PKG_CONFIG=\"${cwsw}/pkgconfig/current/bin/pkg-config\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf \"${rname}\" \"${ridir}/bin/${rname}-openssl\"
  ln -sf \"ualpn\" \"${ridir}/bin/ualpn-openssl\"
  \$(\${CC} -dumpmachine)-strip \"${ridir}/bin/${rname}\" \"${ridir}/bin/ualpn\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

rname="babycurl"
rver="$(cwver_tinycurl)"
rdir="$(cwdir_tinycurl)"
rfile="$(cwfile_tinycurl)"
rdlfile="$(cwdlfile_tinycurl)"
rurl="$(cwurl_tinycurl)"
rsha256="$(cwsha256_tinycurl)"
rreqs="mbedtls libssh2mbedtls make cacertificates pkgconf zlib"

. "${cwrecipe}/common.sh"

for f in clean fetch extract make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_tinycurl
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  env \
    PATH=\"${cwsw}/pkgconf/current/bin:\${PATH}\" \
    PKG_CONFIG=\"${cwsw}/pkgconf/current/bin/pkgconf\" \
      ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
        --disable-ares \
        --disable-dependency-tracking \
        --disable-manual \
        --enable-ipv6 \
        --with-ca-bundle=\"${cwetc}/ssl/cert.pem\"  \
        --with-ca-path=\"${cwetc}/ssl/certs\" \
        --with-default-ssl-backend=mbedtls \
        --with-libssh2 \
        --with-mbedtls \
        --with-zlib \
        --without-{bearssl,brotli,gnutls,libidn2,libssh,nghttp2,nss,openssl,rusttls,wolfssh,wolfssl,zstd} \
          CC=\"\${CC} -Os -Wl,-s\" \
          CFLAGS=\"-Os -Wl,-s \${CFLAGS}\" \
          CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
          LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
          PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  rm -f ${ridir}/bin/* || true
  make install ${rlibtool}
  mv \"${ridir}/bin/curl\" \"${ridir}/bin/${rname}\"
  mv \"${ridir}/bin/curl-config\" \"${ridir}/bin/${rname}-config\"
  ln -s \"${rname}\" \"${ridir}/bin/curl\"
  ln -s \"${rname}\" \"${ridir}/bin/tiny-curl\"
  ln -s \"${rname}\" \"${ridir}/bin/${rname}mbedtls\"
  ln -s \"${rname}\" \"${ridir}/bin/${rname}-mbedtls\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/bin/${rname}\"
  cwmkdir \"${ridir}/devbin\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/devbin/curl\"
  ln -sf \"${rtdir}/current/bin/${rname}-config\" \"${ridir}/devbin/curl-config\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

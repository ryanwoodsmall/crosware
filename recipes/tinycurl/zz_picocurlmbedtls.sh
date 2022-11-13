rname="picocurlmbedtls"
rver="$(cwver_tinycurl)"
rdir="$(cwdir_tinycurl)"
rfile="$(cwfile_tinycurl)"
rdlfile="$(cwdlfile_tinycurl)"
rurl="$(cwurl_tinycurl)"
rsha256=""
rreqs="mbedtls bootstrapmake cacertificates pkgconf zlib"

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
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    PATH=\"${cwsw}/pkgconf/current/bin:\${PATH}\" \
    PKG_CONFIG=\"${cwsw}/pkgconf/current/bin/pkgconf\" \
      ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
        --disable-ares \
        --disable-dependency-tracking \
        --disable-manual \
        --disable-{dict,imap,ldap{,s},ntlm{,-wb},pop3,smb,smtp} \
        --enable-ipv6 \
        --with-ca-bundle=\"${cwetc}/ssl/cert.pem\"  \
        --with-ca-path=\"${cwetc}/ssl/certs\" \
        --with-mbedtls \
        --with-default-ssl-backend=mbedtls \
        --with-zlib \
        --without-{bearssl,brotli,gnutls,libidn2,libssh{,2},nghttp2,nss,openssl,rusttls,wolfssh,wolfssl,zstd} \
          CC=\"\${CC} -g0 -Os -Wl,-s\" \
          CFLAGS=\"-g0 -Os -Wl,-s \${CFLAGS}\" \
          CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
          LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
          PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  rm -f \$(cwidir_${rname})/bin/* || true
  make install ${rlibtool}
  mv \"\$(cwidir_${rname})/bin/curl\" \"\$(cwidir_${rname})/bin/${rname%mbedtls}\"
  mv \"\$(cwidir_${rname})/bin/curl-config\" \"\$(cwidir_${rname})/bin/${rname%mbedtls}-config\"
  ln -s \"${rname%mbedtls}\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -s \"${rname%mbedtls}-config\" \"\$(cwidir_${rname})/bin/${rname}-config\"
  ln -s \"${rname%mbedtls}\" \"\$(cwidir_${rname})/bin/curl\"
  ln -s \"${rname%mbedtls}\" \"\$(cwidir_${rname})/bin/tiny-curl\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/${rname}\"
  cwmkdir \"\$(cwidir_${rname})/devbin\"
  ln -sf \"${rtdir}/current/bin/${rname%mbedtls}\" \"\$(cwidir_${rname})/devbin/curl\"
  ln -sf \"${rtdir}/current/bin/${rname%mbedtls}-config\" \"\$(cwidir_${rname})/devbin/curl-config\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

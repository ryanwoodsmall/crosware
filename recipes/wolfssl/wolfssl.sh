rname="wolfssl"
rver="4.5.0"
rdir="${rname}-${rver}-stable"
rfile="v${rver}-stable.tar.gz"
rurl="https://github.com/wolfSSL/${rname}/archive/${rfile}"
rsha256="7de62300ce14daa0051bfefc7c4d6302f96cabc768b6ae49eda77523b118250c"
rreqs="make perl m4 autoconf automake libtool cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  touch wolfssl/wolfcrypt/fips.h
  touch cyassl/ctaocrypt/fips.h
  env PATH=${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH} libtoolize
  env PATH=${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH} autoreconf -fiv -I${cwsw}/libtool/current/share/aclocal
  sed -i '/^#!/s#/bin/sh#/usr/bin/env bash#g' configure
  bash ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-asm \
    --disable-examples \
    --disable-fips \
    --disable-opensslall \
    --disable-opensslcoexist \
    --disable-opensslextra \
    --enable-aesccm \
    --enable-aesctr \
    --enable-aeskeywrap \
    --enable-anon \
    --enable-arc4 \
    --enable-alpn \
    --enable-atomicuser \
    --enable-blake2 \
    --enable-blake2s \
    --enable-camellia \
    --enable-certext \
    --enable-certgen \
    --enable-certreq \
    --enable-cmac \
    --enable-crl \
    --enable-crl-monitor \
    --enable-curve25519 \
    --enable-curve448 \
    --enable-des3 \
    --enable-dsa \
    --enable-dtls \
    --enable-ecccustcurves \
    --enable-eccencrypt \
    --enable-ed25519 \
    --enable-fpecc \
    --enable-hc128 \
    --enable-hkdf \
    --enable-idea \
    --enable-indef \
    --enable-jobserver=no \
    --enable-keygen \
    --enable-maxfragment \
    --enable-mcast \
    --enable-md2 \
    --enable-md4 \
    --enable-nullcipher \
    --enable-ocsp \
    --enable-ocspstapling \
    --enable-ocspstapling2 \
    --enable-oldnames \
    --enable-pkcallbacks \
    --enable-pkcs7 \
    --enable-pkcs11 \
    --enable-pkcs12 \
    --enable-psk \
    --enable-pwdbased \
    --enable-rabbit \
    --enable-renegotiation-indication \
    --enable-ripemd \
    --enable-rsapss \
    --enable-savecert \
    --enable-savesession \
    --enable-scep \
    --enable-scrypt \
    --enable-session-ticket \
    --enable-singlethreaded \
    --enable-sni \
    --enable-srp \
    --enable-ssh \
    --enable-sslv3 \
    --enable-tls13 \
    --enable-tlsv10 \
    --enable-tlsx \
    --enable-trustedca \
    --enable-truncatedhmac \
    --enable-x963kdf \
      CFLAGS=\"\${CFLAGS}\" \
      LDFLAGS=-static \
      CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  test -e \"${ridir}/include/wolfssl/options.h\" || cp wolfssl/options.h \"${ridir}/include/wolfssl/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"

#
# XXX - replace pem/key/etc. with host-specific stuff at build time with mbedtls/bearssl/x509cert/px5g/...?
# XXX - --enable-haproxy bumps OPENSSL_VERSION_NUMBER _but_ requires openssl bin for renegotiation stuff. ugh
# XXX - stunnel patch from osp applies but doesn't seem to work, old version
# XXX - openvpn upstream requires master and has a number of conflicts with OPENSSL_VERSION_NUMBER/undefined functions
# XXX - need to test nginx osp patch
# XXX - libssh2 patch is clean and build works, older version
# XXX - openssh osp requires some finagling but works, at least ssh/sftp clients
# XXX - socat osp patch is fine, builds clean
#

rname="wolfssl"
rver="5.1.1"
rdir="${rname}-${rver}-stable"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="7dbcb7cf0338ab96e8086d3cd5d0280cedb3646e28bf5d61cc112a4e9b1a7251"
rreqs="make cacertificates configgit slibtool toybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  touch wolfssl/wolfcrypt/fips.h
  touch cyassl/ctaocrypt/fips.h
  sed -i '/^#!/s#/bin/sh#/usr/bin/env bash#g' configure
  bash ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --enable-examples \
    --enable-opensslall \
    --enable-opensslextra \
    --disable-asm \
    --disable-fips \
    --disable-opensslcoexist \
    --enable-aesccm \
    --enable-aescfb \
    --enable-aesctr \
    --enable-aesgcm-stream \
    --enable-aeskeywrap \
    --enable-aesofb \
    --enable-anon \
    --enable-arc4 \
    --enable-alpn \
    --enable-atomicuser \
    --enable-bind \
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
    --enable-ed25519-stream \
    --enable-ed448 \
    --enable-ed448-stream \
    --enable-fpecc \
    --enable-hc128 \
    --enable-hkdf \
    --enable-idea \
    --enable-indef \
    --enable-jobserver=no \
    --enable-keygen \
    --enable-libssh2 \
    --enable-maxfragment \
    --enable-mcast \
    --enable-md2 \
    --enable-md4 \
    --enable-nginx \
    --enable-nullcipher \
    --enable-ocsp \
    --enable-ocspstapling \
    --enable-ocspstapling2 \
    --enable-oldnames \
    --enable-openssh \
    --enable-openvpn \
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
    --enable-sessioncerts \
    --enable-session-ticket \
    --enable-sni \
    --enable-srp \
    --enable-ssh \
    --enable-sslv3 \
    --enable-stunnel \
    --enable-tls13 \
    --enable-tlsv10 \
    --enable-tlsx \
    --enable-trustedca \
    --enable-truncatedhmac \
    --enable-x963kdf \
    --enable-xchacha \
      CFLAGS=\"\${CFLAGS}\" \
      LDFLAGS=-static \
      CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat wolfssl/test.h > wolfssl/test.h.ORIG
  sed -i 's,\./certs/,certs/,g' wolfssl/test.h
  sed -i 's,\"certs/,\"${rtdir}/current/certs/,g' wolfssl/test.h
  sed -i.ORIG 's,\"certs/ocsp,\"${rtdir}/current/certs/ocsp,g' examples/server/server.c
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  test -e \"${ridir}/include/wolfssl/options.h\" || cp wolfssl/options.h \"${ridir}/include/wolfssl/\"
  cwmkdir \"${ridir}/bin\"
  for i in \$(find examples/ -type f -exec \"${cwsw}/toybox/current/bin/toybox\" file {} + | awk -F: '/ELF.*executable/{print \$1}') ; do
    n=\"\$(basename \${i})\"
    install -m 0755 \"\${i}\" \"${ridir}/bin/${rname}-\${n}\"
    \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/bin/${rname}-\${n}\"
  done
  unset i n
  rm -rf \"${ridir}/certs\"
  cwmkdir \"${ridir}/certs\"
  ( cd certs ; tar -cf - . ) | ( cd \"${ridir}/certs/\" ; tar -xf - )
  sed -i 's,${ridir},${rtdir}/current,g' \"${ridir}/bin/${rname}-config\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

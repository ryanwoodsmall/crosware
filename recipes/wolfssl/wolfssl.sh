#
# XXX - replace pem/key/etc. with host-specific stuff at build time with mbedtls/bearssl/x509cert/px5g/...?
# XXX - --enable-haproxy bumps OPENSSL_VERSION_NUMBER _but_ requires openssl bin for renegotiation stuff. ugh
# XXX - stunnel patch from osp applies but doesn't seem to work, old version
# XXX - openvpn upstream requires master and has a number of conflicts with OPENSSL_VERSION_NUMBER/undefined functions
# XXX - apache httpd applies cleanly, but segfaults on request; needs expat/pcre
# XXX - need to test nginx osp patch
# XXX - socat osp patch is fine, builds clean, but dtls+tun crashes passing traffic
# XXX - libssh2 patch is clean and build works, older version
# XXX - openssh osp requires some finagling but works, at least ssh/sftp clients
# XXX - new default disabled options in 5.5.x: --enable-quic --enable-dtlscid
# XXX - docs on QUIC: https://github.com/wolfSSL/wolfssl/blob/master/doc/QUIC.md
# XXX - fix ca certs in src/ssl.c - broken?
# XXX - link in cacertificates/caextract pem in certs/? which files?
# XXX - kyber, shake###, etc.
# XXX - configure needs colrm; bring in baseutils instead of util-linux...
#

rname="wolfssl"
rver="5.6.6"
#rdir="${rname}-${rver}-stable"
#rfile="${rdir}.tar.xz"
#rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/wolfSSL/wolfssl/releases/download/v${rver}-stable/${rfile}"
rsha256="75aaafe3b8c776d1ac417288116c8d444115f9fac5acb382a39a7d163dfd618d"
rreqs="make cacertificates configgit slibtool toybox baseutils"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  touch wolfssl/wolfcrypt/fips.h
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
    --enable-aessiv \
    --enable-anon \
    --enable-arc4 \
    --enable-alpn \
    --enable-atomicuser \
    --enable-bind \
    --enable-blake2 \
    --enable-blake2s \
    --enable-brainpool \
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
    --enable-dtls13 \
    --enable-dtlscid \
    --enable-earlydata \
    --enable-ecccustcurves \
    --enable-eccencrypt \
    --enable-ech \
    --enable-ed25519 \
    --enable-ed25519-stream \
    --enable-ed448 \
    --enable-ed448-stream \
    --enable-fpecc \
    --enable-hkdf \
    --enable-hmac \
    --enable-hpke \
    --enable-indef \
    --enable-jobserver=no \
    --enable-kdf \
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
    --enable-quic \
    --enable-renegotiation-indication \
    --enable-ripemd \
    --enable-rsapss \
    --enable-savecert \
    --enable-savesession \
    --enable-scep \
    --enable-scrypt \
    --enable-sessioncerts \
    --enable-session-ticket \
    --enable-siphash \
    --enable-sni \
    --enable-srp \
    --enable-srtp \
    --enable-ssh \
    --enable-sslv3 \
    --enable-stunnel \
    --enable-sys-ca-certs \
    --enable-tls13 \
    --enable-tlsv10 \
    --enable-tlsx \
    --enable-trustedca \
    --enable-truncatedhmac \
    --enable-wolfssh \
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
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG \"s,/etc/ssl/certs,${cwtop}/etc/ssl/certs,g\" src/ssl.c
  cat wolfssl/test.h > wolfssl/test.h.ORIG
  sed -i 's,\./certs/,certs/,g' wolfssl/test.h
  sed -i 's,\"certs/,\"${rtdir}/current/certs/,g' wolfssl/test.h
  sed -i.ORIG 's,\"certs/ocsp,\"${rtdir}/current/certs/ocsp,g' examples/server/server.c
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  test -e \"\$(cwidir_${rname})/include/wolfssl/options.h\" || cp wolfssl/options.h \"\$(cwidir_${rname})/include/wolfssl/\"
  cwmkdir \"\$(cwidir_${rname})/bin\"
  for i in \$(find examples/ -type f -exec \"${cwsw}/toybox/current/bin/toybox\" file {} + | awk -F: '/ELF.*executable/{print \$1}') ; do
    n=\"\$(basename \${i})\"
    install -m 0755 \"\${i}\" \"\$(cwidir_${rname})/bin/${rname}-\${n}\"
    \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/${rname}-\${n}\"
  done
  unset i n
  rm -rf \"\$(cwidir_${rname})/certs\"
  cwmkdir \"\$(cwidir_${rname})/certs\"
  ( cd certs ; tar -cf - . ) | ( cd \"\$(cwidir_${rname})/certs/\" ; tar -xf - )
  sed -i \"s,\$(cwidir_${rname}),${rtdir}/current,g\" \"\$(cwidir_${rname})/bin/${rname}-config\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

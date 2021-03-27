#
# XXX - uses separate openssldir in ${cwtop}/etc/libressl
# XXX - broken on centos 6, ugh
#
rname="libressl"
rver="3.2.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${rfile}"
rsha256="798a65fd61d385e09d559810cdfa46512f8def5919264cfef241a7b086ce7cfe"
rreqs="make cacertificates configgit zlib nghttp2 pkgconfig"
# prefer openssl for now
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetch_libssh2
  cwfetch_curl
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  cwextract \"\$(cwdlfile_libssh2)\" \"${rbdir}\"
  cwextract \"\$(cwdlfile_curl)\" \"${rbdir}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --disable-asm \
    --enable-nc \
    --with-openssldir=\"${cwetc}/${rname}\" \
    --with-pic \
      CPPFLAGS= \
      LDFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  rm -f \"${ridir}/bin/openssl\" \"${ridir}/bin/${rname}\"
  make install ${rlibtool}
  mv \"${ridir}/bin/openssl\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/openssl\"
  cwmakeinstall_${rname}_libssh2
  cwmakeinstall_${rname}_curl
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}_libssh2() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cd \$(cwdir_libssh2)
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-libssl-prefix=\"${ridir}\" \
    --with-libz \
    --with-pic \
      LDFLAGS=\"-L${ridir}/lib -L${cwsw}/zlib/current/lib -static\" \
      CPPFLAGS=\"-I${ridir}/include -I${cwsw}/zlib/current/include\"
  make -j${cwmakejobs} ${rlibtool}
  make install ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}_curl() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cd \$(cwdir_curl)
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-dependency-tracking \
    --disable-maintainer-mode \
    --enable-ipv6 \
    --with-libssh2 \
    --with-nghttp2 \
    --with-ssl \
    --with-zlib \
    --without-hyper \
    --without-libidn2 \
    --without-zstd \
    --without-libmetalink \
    --without-bearssl \
    --without-wolfssl \
    --without-gnutls \
    --without-mbedtls \
    --with-default-ssl-backend=openssl \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
    --with-ca-path=\"${cwetc}/ssl/certs\" \
      LDFLAGS=\"-L${cwsw}/zlib/current/lib -L${ridir}/lib -static\" \
      CPPFLAGS=\"-I${cwsw}/zlib/current/include -I${ridir}/include\" \
      PKG_CONFIG_PATH=\"${cwsw}/nghttp2/current/lib/pkgconfig:${ridir}/lib/pkgconfig\" \
      PKG_CONFIG_LIBDIR=\"${cwsw}/nghttp2/current/lib/pkgconfig:${ridir}/lib/pkgconfig\"
  make -j${cwmakejobs} ${rlibtool}
  rm -f \"${ridir}/bin/curl\" \"${ridir}/bin/curl-${rname}\"
  make install ${rlibtool}
  install -m 0755 src/curl \"${ridir}/bin/curl-${rname}\"
  ln -sf \"${rtdir}/current/bin/curl-${rname}\" \"${ridir}/bin/curl\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/openssl/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${cwsw}/curl/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"

#
# XXX - options to check/support:
#   --enable-heartbeat-support
#   --enable-srp-authentication
#   --without-brotli
#   --without-zlib
#   --without-zstd
#
# XXX - 3.8.4 breaks static linking with numerous multiple definition errors w/nettle+gmp+hogweed by "fixing static linking."
#   rver="3.8.4"
#   rsha256="2bea4e154794f3f00180fa2a5c51fe8b005ac7a31cd58bd44cdfa7f36ebc3a9b"
# just great, glad they didn't bundle security advisory bug fixes with feature "enhancments." oh wait, what's that?
#
rname="gnutls"
rver="3.8.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.gnupg.org/ftp/gcrypt/${rname}/v${rver%.*}/${rfile}"
rsha256="f74fc5954b27d4ec6dfbb11dea987888b5b124289a3703afcada0ee520f4173e"
rreqs="make sed byacc nettle gmp libtasn1 libunistring pkgconfig slibtool cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat configure > configure.ORIG
  sed -i \"s,/etc/${rname}/config,${cwetc}/${rname}/config,g\" configure
  sed -i \"s,/etc/unbound/root.key,${cwetc}/${rname}/unbound/root.key,g\" configure
  sed -i s,-Wmissing-include-dirs,,g configure
  sed -i.ORIG \"s,/etc/ssl/certs/ca-certificates.crt,${cwetc}/ssl/cert.pem,g\" doc/examples/*.c doc/examples/*.h doc/examples/tlsproxy/*.c doc/examples/tlsproxy/*.h
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --disable-doc \
    --disable-gtk-doc{,-{html,pdf}} \
    --disable-hardware-acceleration \
    --disable-nls \
    --disable-openssl-compatibility \
    --disable-padlock \
    --disable-silent-rules \
    --enable-manpages \
    --enable-sha1-support \
    --enable-ssl3-support \
    --with-default-trust-store-dir=\"${cwetc}/ssl/certs\" \
    --with-default-trust-store-file=\"${cwetc}/ssl/cert.pem\" \
    --with-unbound-root-key-file=\"${cwetc}/${rname}/unbound/root.key\" \
    --without-idn \
    --without-p11-kit \
    --without-tpm{,2} \
    --without-{zlib,zstd,brotli} \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      PKG_CONFIG=\"${cwsw}/pkgconfig/current/bin/pkg-config\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  cd doc/examples/tlsproxy
  \${CC} \
    buffer.c crypto-gnutls.c tlsproxy.c \
    -o ${rname}-tlsproxy \
    -I../../../ -I\$(cwidir_${rname})/include \$(echo -I${cwsw}/{${rreqs// /,}}/current/include) \
    -L\$(cwidir_${rname})/lib \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) \
    -lgnutls -lhogweed -lnettle -lgmp -ltasn1 -lunistring -static
  install -m 755 ${rname}-tlsproxy \$(cwidir_${rname})/bin/
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
